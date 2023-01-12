//
//  LogInViewController.swift
//  GroceryListApplication

import UIKit
import FirebaseAuth
import Firebase

class LogInViewController: UIViewController {
    
    // IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // IBAction
    @IBAction func logInAction(_ sender: Any) {
        guard
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
            // Check if any requairment information is empty will show error message
            let alertController = UIAlertController(title: "Error", message: "Please fill all the information", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            return
        }
        
        if !emailTextField.isEmail(){
            // Check if email is not match email format will show error message
            let alertController = UIAlertController(title: "Error", message: "Please enter correct email", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error{
                // Check if password is wrong will show error message, else will get the user online
                let alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel)
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
                return
            }else{
                let userReference = Database.database().reference(fromURL: "grocery-e745e-default-rtdb").child("Online")
                let values: [String: String] = ["\(authResult!.user.uid)": email]
                
                userReference.updateChildValues(values, withCompletionBlock: {(error, usersRef)in
                    if error != nil {
                        print(error!)
                        return
                    } // End if
                }
                )
                
                // Show GroceryToBuyViewController
                let GroceriesToBuyVC = self.storyboard?.instantiateViewController(withIdentifier: "GroceriesToBuyViewController") as! GroceriesToBuyViewController
                self.navigationController?.pushViewController(GroceriesToBuyVC, animated: true)
                
            } // End else
        }
    } // End logInAction
    
    
    @IBAction func signUpAction(_ sender: Any) {
        // Show RegisterViewController
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
    } // End signUpAction
    
} // End class
