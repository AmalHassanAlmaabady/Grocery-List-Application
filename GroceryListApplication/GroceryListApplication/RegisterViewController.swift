//
//  RegisterViewController.swift
//  GroceryListApplication
//
//  Created by Eman on 16/06/1444 AH.
//

import UIKit
import FirebaseAuth
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func signUpAction(_ sender: Any) {
        
        guard
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
 
        else {
            let alertController = UIAlertController(title: "Error", message: "Please fill all the information", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            
            return
        }
        if !emailTextField.isEmail(){
            let alertController = UIAlertController(title: "Error", message: "Please enter correct email", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            return
        }
        if password.count < 6 {
            let alertController = UIAlertController(title: "Error", message: "The password must be 6 characters or more", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: {(authResult, error: Error?) in
            if error != nil {
                let alertController = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel)
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
                return
            }
            
            let uid = authResult!.user.uid
            let db = Firestore.firestore()
            
            db.collection("Family").document(uid).setData([
                "Email": self.emailTextField.text!
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let groceriesToBuyVC = storyBoard.instantiateViewController(withIdentifier: "GroceriesToBuyViewController") as! GroceriesToBuyViewController
            groceriesToBuyVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(groceriesToBuyVC, animated: true)
            groceriesToBuyVC.navigationItem.hidesBackButton = true
        })
    }
    
}
