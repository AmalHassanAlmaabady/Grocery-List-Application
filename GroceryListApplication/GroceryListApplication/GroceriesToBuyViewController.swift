//
//  GroceriesToBuyViewController.swift
//  GroceryListApplication
//
//  Created by Eman on 15/06/1444 AH.
//

import UIKit

class GroceriesToBuyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellId = "GroceriesToBuy"
    var groceriesArray : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Groceries To Buy"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addItem(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.family(_:)))

        // Do any additional setup after loading the view.
    }
    
    @objc func addItem(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Grocery Item", message: "Add an Item", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField! ) -> Void in
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let itemTextField = alertController.textFields![0] as UITextField
            if itemTextField.text != ""{
                self.groceriesArray.append(itemTextField.text!)
            }
            self.tableView.reloadData()
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
        groceriesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GrocertiesToBuyTableViewCell", for: indexPath) as! GrocertiesToBuyTableViewCell
        
        cell.title.text = groceriesArray[indexPath.row]
        return cell
    }

}
