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
    var img: [UIImage]
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
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.lk_registerCellWithNib(identifier: "UnboxCollectionViewCell", bundle: nil)
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
    var imgAry: [UIImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
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

extension UnboxingViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgAry.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnboxCollectionViewCell", for: indexPath) as? UnboxCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.item == 0 {
            cell.unboxImg.contentMode = .center
            cell.cancelImg.isHidden = true
            cell.unboxImg.image = UIImage(systemName: "photo")
        } else {
            cell.unboxView.layer.borderWidth = 0
            cell.unboxImg.image = imgAry[indexPath.item - 1]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return itemSpace
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return itemSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        } else {
            imgAry.remove(at: indexPath.item - 1)
            delegate?.passDataToCreatePost(unboxingVC: self)
        }
    }
    
}

extension UnboxingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        // 取得從 UIImagePickerController 選擇的檔案
        if let pickedImage = info[.originalImage] as? UIImage {
            imgAry.append(pickedImage)
        }
        delegate?.passDataToCreatePost(unboxingVC: self)
        
        dismiss(animated: true, completion: nil)
    }
}
