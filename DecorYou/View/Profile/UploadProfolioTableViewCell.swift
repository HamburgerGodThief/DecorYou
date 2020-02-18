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
    let pickerView = UIPickerView()
    let areaData: [String] = ["客廳", "餐廳", "主臥室", "房間一", "廚房", "浴廁"]
    var selectedPhotos: [UIImage] = []
    let itemSpace = CGFloat(4)
    let columnCount = CGFloat(4)
    var cellVC: UploadProfolioViewController?
    var indexPathRow: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        areaTextField.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        // Initialization code
        newPhotoCollectionView.lk_registerCellWithNib(identifier: String(describing: ProfolioCollectionViewCell.self), bundle: nil)
        newPhotoCollectionView.delegate = self
        newPhotoCollectionView.dataSource = self
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
        guard let cellVC = cellVC else { return }
        cellVC.selectAreaInTableView[pickerView.tag] = areaData[row]
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return areaData[row]
    }

}

extension UploadProfolioTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedPhotos.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProfolioCollectionViewCell.self), for: indexPath) as? ProfolioCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.item == 0 {
            cell.portfolioImg.contentMode = .scaleAspectFill
            cell.portfolioImg.image = UIImage.asset(.Icons_24px_AddPhoto)
        } else {
            cell.portfolioImg.image = selectedPhotos[indexPath.item - 1]
        }
        cell.portfolioImg.backgroundColor = .lightGray
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        guard let photosViewController = storyboard.instantiateViewController(withIdentifier: "PhotosViewController") as? PhotosViewController else { return }
        guard let uploadProfolioVC = cellVC else { return }
        photosViewController.indexPathRow = indexPathRow
        photosViewController.parentVC = uploadProfolioVC
        uploadProfolioVC.present(photosViewController, animated: true, completion: nil)
    }

}
