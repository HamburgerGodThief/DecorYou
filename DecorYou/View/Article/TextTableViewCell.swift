//
//  TextTableViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/3/8.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
