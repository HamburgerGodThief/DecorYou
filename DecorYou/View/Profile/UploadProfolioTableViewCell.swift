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
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var newPhotoBtn: UIButton!
    
    let pickerView = UIPickerView()
    let areaData: [String] = ["客廳", "餐廳", "主臥室", "房間一", "廚房", "浴廁"]
    var selectedPhotos: [UIImage] = [] {
        didSet {
            if selectedPhotos.isEmpty {
                shouldShowNewPhotoBtn(shouldShow: true)
            } else {
                shouldShowNewPhotoBtn(shouldShow: false)
            }
        }
    }
    let itemSpace = CGFloat(4)
    let columnCount = CGFloat(4)
    var cellVC: UploadProfolioViewController?
    var indexPathRow: Int?
    
    @IBAction func addPhoto(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        guard let photosViewController = storyboard.instantiateViewController(withIdentifier: "PhotosViewController") as? PhotosViewController else { return }
        guard let uploadProfolioVC = cellVC else { return }
        photosViewController.indexPathRow = indexPathRow
        photosViewController.parentVC = uploadProfolioVC
        uploadProfolioVC.present(photosViewController, animated: true, completion: nil)
        
    }
    
    func shouldShowNewPhotoBtn(shouldShow: Bool) {
        if shouldShow {
            newPhotoBtn.tintColor = .black
            newPhotoBtn.setTitle("新增該區域照片", for: .normal)
            newPhotoBtn.setImage(UIImage.asset(.Icons_24px_AddPhoto), for: .normal)
        } else {
            newPhotoBtn.tintColor = .black
            newPhotoBtn.setTitle("", for: .normal)
            newPhotoBtn.setImage(nil, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        areaTextField.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        newPhotoCollectionView.lk_registerCellWithNib(identifier: String(describing: ProfolioCollectionViewCell.self), bundle: nil)
        newPhotoCollectionView.delegate = self
        newPhotoCollectionView.dataSource = self
        shouldShowNewPhotoBtn(shouldShow: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        guard let cellVC = cellVC else { return }
        cellVC.selectAreaInTableView[pickerView.tag] = areaData[row]
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return areaData[row]
    }

}

extension UploadProfolioTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProfolioCollectionViewCell.self), for: indexPath) as? ProfolioCollectionViewCell else { return UICollectionViewCell() }
        cell.profolioImg.contentMode = .scaleAspectFill
        cell.profolioImg.image = selectedPhotos[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(floor((collectionView.bounds.width - itemSpace * (columnCount-1)) / columnCount))
        let height = width
        return CGSize(width: width, height: height)
    }

    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return itemSpace
    }

    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return itemSpace
    }
    
}
