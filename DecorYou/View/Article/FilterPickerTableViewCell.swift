//
//  FilterPickerTableViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/21.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class FilterPickerTableViewCell: UITableViewCell {

    @IBOutlet weak var locationTextField: UITextField!
    let pickerView = UIPickerView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
