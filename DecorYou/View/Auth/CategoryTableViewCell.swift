//
//  CategoryTableViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/26.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var cateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        backView.layer.cornerRadius = backView.frame.height / 2
    }
    
}
