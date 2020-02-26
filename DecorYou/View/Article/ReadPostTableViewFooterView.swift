//
//  ReadPostTableViewFooterView.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/11.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class ReadPostTableViewFooterView: UIView {
    
    @IBOutlet weak var textFieldBorderView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    var order: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textFieldBorderView.layer.cornerRadius = textFieldBorderView.frame.height / 2
        textFieldBorderView.layer.borderColor = UIColor.assetColor(.mainColor)?.cgColor
        textFieldBorderView.layer.borderWidth = 2
    }
}
