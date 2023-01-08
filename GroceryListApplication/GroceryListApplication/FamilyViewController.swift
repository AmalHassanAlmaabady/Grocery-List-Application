//
//  FamilyViewController.swift
//  GroceryListApplication
//
//  Created by Eman on 15/06/1444 AH.
//

import UIKit

class FamilyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Family (online)"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(self.family(_:)))
        // Do any additional setup after loading the view.
    }
    
    @objc func family(_ sender: UIBarButtonItem) {
        
    }

}
