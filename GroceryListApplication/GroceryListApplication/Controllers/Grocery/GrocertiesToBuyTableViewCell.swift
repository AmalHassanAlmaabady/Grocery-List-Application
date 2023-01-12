//
//  GrocertiesToBuyTableViewCell.swift
//  GroceryListApplication


import UIKit

class GrocertiesToBuyTableViewCell: UITableViewCell {

    // IBOutlet
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var subTitle : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
