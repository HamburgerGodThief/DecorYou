//
//  NewProfileCollectionViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/24.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class NewProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tabTitleLabel: UILabel!
    
    var touchHandler: ((NewProfileCollectionViewCell) -> Void)?
    
}
