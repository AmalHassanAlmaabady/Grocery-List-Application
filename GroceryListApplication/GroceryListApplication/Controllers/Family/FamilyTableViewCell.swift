//
//  FamilyTableViewCell.swift
//  GroceryListApplication


import UIKit

class FamilyTableViewCell: UITableViewCell {

    // IBOutlet
    @IBOutlet weak var subTitle : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
