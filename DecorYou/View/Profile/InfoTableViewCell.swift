//
//  InfoTableViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/4.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    func setting() {
        textField.addLine(position: LINE_POSITION.LINE_POSITION_BOTTOM, color: .white, width: 3)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setting()
        backgroundColor = .brown
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
