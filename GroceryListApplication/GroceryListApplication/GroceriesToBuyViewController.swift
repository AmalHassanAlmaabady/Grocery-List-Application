//
//  GroceriesToBuyViewController.swift
//  GroceryListApplication
//
//  Created by Eman on 15/06/1444 AH.
//

import UIKit
import Firebase
import FirebaseAuth

class GroceriesToBuyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellId = "GroceriesToBuy"
    var groceryItems = [NSDictionary]()
    var chengeTheItem : UITextField?
    var isComplete = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Groceries To Buy"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addItem(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.family(_:)))
        fetchItems()
    }
    
    func fetchItems() {
        let dataReference = Database.database().reference().child("grocery-items")
        dataReference.observe(.value) { snapshot, error in
            self.groceryItems.removeAll()
            if let dictionary = snapshot.value as? NSDictionary {
                DispatchQueue.main.async {
                    for groceryItem in dictionary{
                        self.groceryItems.append(groceryItem.value as! NSDictionary)
                    }
                    self.tableView.reloadData()
                }
            }else{
                self.tableView.reloadData()
            }
        }
    }
    
    func updateItems( item: String, id : String, complete : Bool ){
        let dataReference = Database.database().reference().child("grocery-items").child("\(id)")
        dataReference.setValue(["name" : item, "addByUser" : Auth.auth().currentUser?.email! as Any, "id" : "\(id)", "complete" : complete])
    }
    
    @objc func addItem(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Grocery Item", message: "Add an Item", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField! ) -> Void in
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let itemTextField = alertController.textFields![0] as UITextField
            if itemTextField.text != ""{
                let id = UUID()
                let reference = Database.database().reference(fromURL: "grocery-e745e-default-rtdb").child("grocery-items").child("\(id)")
                let values = ["addByUser" : Auth.auth().currentUser?.email! as Any,
                              "complete" : self.isComplete,
                              "name" : itemTextField.text!,
                              "id" : "\(id)"]
                reference.setValue(values)
                
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    @objc func family(_ sender: UIBarButtonItem) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let familyViewController = storyBoard.instantiateViewController(withIdentifier: "FamilyViewController") as! FamilyViewController
//        self.present(familyViewController, animated:true, completion:nil)
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "FamilyViewController") as! FamilyViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groceryItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GrocertiesToBuyTableViewCell", for: indexPath) as! GrocertiesToBuyTableViewCell
        cell.title.text = groceryItems[indexPath.row]["name"] as? String
        cell.subTitle.text = groceryItems[indexPath.row]["addByUser"] as? String
        if groceryItems[indexPath.row]["complete"] as! Bool == false {
            cell.accessoryType = .none
        }else{
            cell.accessoryType = .checkmark
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: (groceryItems[indexPath.row]["name"] as! String), message: "", preferredStyle: .alert)
        
        let editAction = UIAlertAction(title: "Edit", style: .default){ action in
            let alertController = UIAlertController(title: "Edit", message: "", preferredStyle: .alert)
            alertController.addTextField{ textFild in
                self.chengeTheItem = textFild
                self.chengeTheItem?.text = self.groceryItems[indexPath.row]["name"] as? String
            }
            
            let updateAction = UIAlertAction(title: "Update", style: .default){ action in
                self.updateItems(item: (self.chengeTheItem?.text)!, id: self.groceryItems[indexPath.row]["id"] as! String, complete: self.isComplete)
                tableView.reloadData()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(updateAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
        
        var complateAction = UIAlertAction()
        if let checkMark = tableView.cellForRow(at: indexPath as IndexPath) {
            if checkMark.accessoryType == .checkmark {
                 complateAction = UIAlertAction(title: "Discomplate", style: .default){ action in
                     checkMark.accessoryType = .none
                     self.isComplete = false
                     self.updateItems(item: self.groceryItems[indexPath.row]["name"] as! String, id: self.groceryItems[indexPath.row]["id"] as! String, complete: self.isComplete)
                }
            }else {
                 complateAction = UIAlertAction(title: "Complate", style: .default){ action in
                    checkMark.accessoryType = .checkmark
                     self.isComplete = true
                     self.updateItems(item: self.groceryItems[indexPath.row]["name"] as! String, id: self.groceryItems[indexPath.row]["id"] as! String, complete: self.isComplete)
                }
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(editAction)
        alertController.addAction(complateAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
   }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let dataReference = Database.database().reference().child("grocery-items").child("\(groceryItems[indexPath.row]["id"] as! String)")
        dataReference.removeValue()
    }
}
