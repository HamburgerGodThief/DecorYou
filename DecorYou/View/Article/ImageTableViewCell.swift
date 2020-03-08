//
//  ImageTableViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/3/8.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var removeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        removeBtn.imageView?.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
