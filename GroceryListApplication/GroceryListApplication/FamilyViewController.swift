//
//  FamilyViewController.swift
//  GroceryListApplication
//
//  Created by Eman on 15/06/1444 AH.
//

import UIKit
import FirebaseAuth
import Firebase

class FamilyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyTableViewCell", for: indexPath) as! FamilyTableViewCell
            cell.subTitle.text = onlineUsers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        onlineUsers.count
    }
    

    @IBOutlet weak var tableView: UITableView!
    var onlineUsers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.title = "Family (online)"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(self.signOut(_:)))
        fetchItems()
        // Do any additional setup after loading the view.
    }
    
    func fetchItems() {
        let dataReference = Database.database().reference().child("Online")
        dataReference.observe(.value) { snapshot, error in
            self.onlineUsers.removeAll()
            if let dictionary = snapshot.value as? NSDictionary {
                DispatchQueue.main.async {
                    for groceryItem in dictionary{
                        let currentUser = groceryItem.value as! String
                        if Auth.auth().currentUser?.email != currentUser{
                            self.onlineUsers.append(groceryItem.value as! String)
                        }else if self.onlineUsers.count == 0{
                            self.tableView.reloadData()
                        }
                    }
                    self.tableView.reloadData()
                }
            }else{
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func signOut(_ sender: UIBarButtonItem) {
        if Auth.auth().currentUser != nil {
            do {
                let userId = Auth.auth().currentUser?.uid
                try Auth.auth().signOut()
                Database.database().reference().child("Online").child("\(userId!)").removeValue()
                
                navigationController?.popToRootViewController(animated: true)
                
            }catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
