//
//  ArticleListTableViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/19.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class ArticleListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameAndCreateTime: UILabel!
    @IBOutlet weak var replyCount: UILabel!
    @IBOutlet weak var loveCount: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
