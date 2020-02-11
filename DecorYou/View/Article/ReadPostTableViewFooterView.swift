//
//  ReadPostTableViewFooterView.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/11.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class ReadPostTableViewFooterView: UIView {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    var order: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentTextField.layer.cornerRadius = 16
        commentTextField.layer.borderColor = UIColor.assetColor(.mainColor)?.cgColor
        commentTextField.layer.borderWidth = 2
    }
}
