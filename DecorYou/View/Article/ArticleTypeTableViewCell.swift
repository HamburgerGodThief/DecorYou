//
//  ArticleTypeTableViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/27.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class ArticleTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        backView.layer.cornerRadius = backView.frame.height / 2
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = backView.frame.height / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
