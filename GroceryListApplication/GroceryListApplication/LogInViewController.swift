//
//  LogInViewController.swift
//  GroceryListApplication
//
//  Created by Eman on 16/06/1444 AH.
//

import UIKit
import FirebaseAuth
import Firebase

class LogInViewController: UIViewController {

    var r : DatabaseReference!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func logInAction(_ sender: Any) {
        guard
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
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
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error{
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
                    }
                    print("Save user succeddfully into Firebase db")
                    
                }
                )
                
                let GroceriesToBuyVC = self.storyboard?.instantiateViewController(withIdentifier: "GroceriesToBuyViewController") as! GroceriesToBuyViewController
                self.navigationController?.pushViewController(GroceriesToBuyVC, animated: true)
                
            }
        }
    }
    
    
    @IBAction func signUpAction(_ sender: Any) {
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
//        let signUpVC = RegisterViewController()
//        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
}
