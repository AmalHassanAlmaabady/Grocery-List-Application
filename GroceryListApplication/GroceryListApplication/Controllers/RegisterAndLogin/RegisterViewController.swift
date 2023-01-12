//
//  RegisterViewController.swift
//  GroceryListApplication

import UIKit
import FirebaseAuth
import Firebase

class RegisterViewController: UIViewController {
    
    // IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // IBAction
    @IBAction func signUpAction(_ sender: Any) {
        guard
            // Check if any requairment information is empty will show error message
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
            let alertController = UIAlertController(title: "Error", message: "Please fill all the information", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            return
        }
        // Check if email is not match email format will show error message
        if !emailTextField.isEmail(){
            let alertController = UIAlertController(title: "Error", message: "Please enter correct email", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            return
        }
        // Check if password is less than 6 digits will show error message
        if password.count < 6 {
            let alertController = UIAlertController(title: "Error", message: "The password must be 6 characters or more", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            return
        }
        
        
        Auth.auth().createUser(withEmail: email, password: password, completion: {(authResult, error: Error?) in
            if error != nil {
                // Check if email is already register will show error message, else will create account
                let alertController = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel)
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
                return
            }

            // Show LogInViewController
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let logInVC = storyBoard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
            logInVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(logInVC, animated: true)
            logInVC.navigationItem.hidesBackButton = true
        })
    } // End signUpAction
    
} // End class
