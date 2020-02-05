//
//  ProfileTableViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/4.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var functionLabel: UILabel!
    
    let topInset: CGFloat = 10
    let bottomInset: CGFloat = 10
    let leftInset: CGFloat = 10
    let rightInset: CGFloat = 10
    
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        layoutMargins = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    }
    override func setNeedsLayout() {
        super.setNeedsLayout()
        layoutMargins = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)

    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
