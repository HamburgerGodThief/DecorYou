//
//  YourPostTableViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/5.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class YourPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var loveLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backView.layer.cornerRadius = backView.frame.height / 2
    }
    
}
