//
//  NewPostTableViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/1/31.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class NewPostTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var ugcLabel: UILabel!
    @IBOutlet weak var logoCollectionView: UICollectionView!
    
    func fillData(iconImg: UIImage, optionLabelText: String) {
        self.iconImg.image = iconImg
        self.optionLabel.text = optionLabelText
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
