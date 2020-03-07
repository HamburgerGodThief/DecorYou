//
//  UnboxingViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/29.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

struct UnboxTag {
    var size: Int
    var location: String
    var style: String
}

protocol UnboxingViewControllerDelegate: AnyObject {
    
    func passDataToCreatePost(unboxingVC: UnboxingViewController)
    
}

class UnboxingViewController: UIViewController {
    
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var locationTextView: UITextField! {
        didSet {
            locationTextView.inputView = locationPickerView
        }
    }
    @IBOutlet weak var styleTextView: UITextField! {
        didSet {
            styleTextView.inputView = stylePickerView
        }
    }
    
    weak var delegate: UnboxingViewControllerDelegate?
    let locationPickerView = UIPickerView()
    let stylePickerView = UIPickerView()
    let area_data = ["臺北市", "新北市", "基隆市", "桃園市", "新竹縣",
                     "新竹市", "苗栗縣", "臺中市", "南投縣", "彰化縣",
                     "雲林縣", "嘉義縣", "嘉義市", "臺南市", "高雄市",
                     "屏東縣", "宜蘭縣", "花蓮縣", "臺東縣", "澎湖縣",
                     "金門縣", "連江縣"]
    let style_data = ["工業", "後現代", "日系",
                      "黑白色調", "森林", "清新",
                      "輕工業", "木質調", "奢華",
                      "北歐", "古典", "鄉村",
                      "地中海", "美式", "東方", "無特定"]
    var locationSelected: String = ""
    var styleSelected: String = ""
    var size: Int = 0
    let itemSpace: CGFloat = 16

    override func viewDidLoad() {
        super.viewDidLoad()
        locationPickerView.delegate = self
        locationPickerView.dataSource = self
        stylePickerView.delegate = self
        stylePickerView.dataSource = self
        sizeTextField.delegate = self
        locationTextView.delegate = self
        styleTextView.delegate = self
        // Do any additional setup after loading the view.
    }
}

extension UnboxingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == locationPickerView {
            return area_data.count
        } else {
            return style_data.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == locationPickerView {
            locationSelected = area_data[row]
            locationTextView.text = area_data[row]
        } else {
            styleSelected = style_data[row]
            styleTextView.text = style_data[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == locationPickerView {
            return area_data[row]
        } else {
            return style_data[row]
        }
    }
    
}

extension UnboxingViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == sizeTextField {
            guard let text = textField.text else { return }
            size = Int(text) ?? 0
        }
        delegate?.passDataToCreatePost(unboxingVC: self)
    }
        
}
