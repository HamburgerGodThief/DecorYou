//
//  FilterCollectionTableViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/20.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class FilterCollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
