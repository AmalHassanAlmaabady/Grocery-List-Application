//
//  FamilyViewController.swift
//  GroceryListApplication


import UIKit
import FirebaseAuth
import Firebase

class FamilyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // Array to save the email of online users
    var onlineUsers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.title = "Family (online)"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(self.signOut(_:)))
        
        fetchUsers()
    }
    
    func fetchUsers() {
        let dataReference = Database.database().reference().child("Online")
        dataReference.observe(.value) { snapshot, error in
            self.onlineUsers.removeAll()
            if let dictionary = snapshot.value as? NSDictionary {
                DispatchQueue.main.async {
                    for onlineUser in dictionary{
                        // Check if the email from realtime database not match current user email will save into array or check if all users are offline
                        let currentUser = onlineUser.value as! String
                        if Auth.auth().currentUser?.email != currentUser{
                            self.onlineUsers.append(onlineUser.value as! String)
                        }else if self.onlineUsers.count == 0{
                            self.tableView.reloadData()
                        } // End else if
                    } // End for loop
                    self.tableView.reloadData()
                }
            }else{
                self.tableView.reloadData()
            } // End else
        }
    } // End fetchUsers function
    
    @objc func signOut(_ sender: UIBarButtonItem) {
        if Auth.auth().currentUser != nil {
            do {
                // Sign out and remove user from realtime database
                let userId = Auth.auth().currentUser?.uid
                try Auth.auth().signOut()
                Database.database().reference().child("Online").child("\(userId!)").removeValue()
                
                // Show LogInViewController
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let logInVC = storyBoard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
                logInVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(logInVC, animated: true)
                logInVC.navigationItem.hidesBackButton = true
                
            }catch let error as NSError {
                print(error.localizedDescription)
            } // End catch
        } // End if
    } // End signOut function
    
    
    // Table view functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyTableViewCell", for: indexPath) as! FamilyTableViewCell
        cell.subTitle.text = onlineUsers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        onlineUsers.count
    }
    
} // End class
