//
//  FilterTableViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/20.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var minValueTextField: UITextField!
    @IBOutlet weak var maxValueTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        minValueTextField.delegate = self
        maxValueTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension FilterTableViewCell: UITextFieldDelegate {
    
}
