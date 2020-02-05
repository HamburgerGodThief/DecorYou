//
//  ReadPostBottomView.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/5.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class ReadPostBottomView: UIView {
    
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet weak var jumpFloorBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    
    func setLabelUI() {
        replyBtn.layer.cornerRadius = 10
        replyBtn.layer.borderColor = UIColor.darkGray.cgColor
        replyBtn.layer.borderWidth = 2
        replyBtn.setTitle("  回覆文章", for: .normal)
        replyBtn.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLabelUI()
    }
}
