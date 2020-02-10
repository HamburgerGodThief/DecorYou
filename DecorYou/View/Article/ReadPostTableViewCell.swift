//
//  ReadPostTableViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/10.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class ReadPostTableViewCell: UITableViewCell {

    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    @IBAction func didTouchReport(_ sender: Any) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        logoImg.layer.cornerRadius = logoImg.frame.size.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
