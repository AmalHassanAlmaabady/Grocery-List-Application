//
//  FamilyViewController.swift
//  GroceryListApplication
//
//  Created by Eman on 15/06/1444 AH.
//

import UIKit
import FirebaseAuth

class FamilyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Family (online)"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(self.signOut(_:)))
        // Do any additional setup after loading the view.
    }
    
    @objc func signOut(_ sender: UIBarButtonItem) {
        if Auth.auth().currentUser != nil {
               do {
                   try Auth.auth().signOut()
//                   let logInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
                   navigationController?.popToRootViewController(animated: true)
//                   logInVC.modalPresentationStyle = .fullScreen
//                   logInVC.navigationItem.hidesBackButton = true
//                   present(logInVC, animated: true, completion: nil)

               } catch let error as NSError {
                   print(error.localizedDescription)
               }
           }
    }

}
