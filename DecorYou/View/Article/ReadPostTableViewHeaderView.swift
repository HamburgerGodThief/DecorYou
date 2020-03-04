//
//  ReadPostTableViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/5.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class ReadPostTableViewHeaderView: UIView {

    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var floorTimeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        logoImg.layer.cornerRadius = logoImg.frame.size.width / 2
    }
}
