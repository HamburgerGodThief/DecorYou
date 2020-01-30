//
//  ArticleTableViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/1/31.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var authorImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTimeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        authorImgView.layer.cornerRadius = self.authorImgView.frame.size.width / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillData(authorImgView: String, titleLabel: String, nameTimeLabel: String, contentLabel: String) {
        self.authorImgView.loadImage(authorImgView)
        self.titleLabel.text = titleLabel
        self.nameTimeLabel.text = nameTimeLabel
        self.contentLabel.text = contentLabel
    }
}
