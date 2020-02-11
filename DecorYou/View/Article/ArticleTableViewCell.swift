//
//  ArticleTableViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/1/31.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var authorImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTimeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 20
        authorImgView.layer.cornerRadius = authorImgView.frame.size.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillData(authorImgURLString: String?, titleLabel: String, nameTimeLabel: String, contentLabel: String) {
        
        self.authorImgView.loadImage(authorImgURLString, placeHolder: UIImage(systemName: "person.circle"))
        self.titleLabel.text = titleLabel
        self.nameTimeLabel.text = nameTimeLabel
        self.contentLabel.text = contentLabel
    }
}
