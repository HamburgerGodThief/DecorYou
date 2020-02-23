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
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var seeMoreBtn: UIButton!
    
    @IBAction func seeMore(_ sender: Any) {
        seeMoreBtn.isSelected.toggle()
        if seeMoreBtn.isSelected {
            collectionHeightConstraint.constant = 320
        } else {
            collectionHeightConstraint.constant = 80
        }
        guard let tableView = superview as? UITableView else { return }
        tableView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.isScrollEnabled = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
