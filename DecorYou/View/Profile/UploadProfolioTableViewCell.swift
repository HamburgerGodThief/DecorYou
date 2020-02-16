//
//  UploadProfolioTableViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/15.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class UploadProfolioTableViewCell: UITableViewCell {

    @IBOutlet weak var newPhotoCollectionView: UICollectionView!
    @IBOutlet weak var areaTextField: UITextField!
    let pickerView = UIPickerView()
    let areaData: [String] = ["客廳", "主臥室", "廚房", "次臥室"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        areaTextField.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UploadProfolioTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return areaData.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        areaTextField.text = areaData[row]
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return areaData[row]
    }

}
