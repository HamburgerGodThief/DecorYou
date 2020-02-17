//
//  UploadProfolioViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/15.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit
import Photos
import FirebaseStorage
import FirebaseDatabase

class UploadProfolioViewController: UIViewController {
    
    @IBOutlet weak var newProfolioTableView: UITableView!
    var selectAreaInTableView: [String] = [] {
        didSet {
            newProfolioTableView.reloadData()
        }
    }
    var selectedPhotoInTableView: [[UIImage]] = [] {
        didSet {
            newProfolioTableView.reloadData()
        }
    }
    
    func setNav() {
        navigationItem.title = "新增作品"
        let rightBtn = UIBarButtonItem(title: "送出", style: .plain, target: self, action: #selector(createProfolio))
        let leftBtn = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = rightBtn
        navigationItem.leftBarButtonItem = leftBtn
    }
    
    func setTableView() {
        newProfolioTableView.delegate = self
        newProfolioTableView.dataSource = self
        newProfolioTableView.lk_registerCellWithNib(identifier: String(describing: UploadProfolioTableViewCell.self), bundle: nil)
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        customView.backgroundColor = UIColor.red
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        button.setTitle("＋ 新增區域", for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "＋ 新增區域", attributes: [
        .foregroundColor: UIColor.black,
        .font: UIFont(name: "PingFangTC-Medium", size: 24)!]), for: .normal)
        button.addTarget(self, action: #selector(newArea), for: .touchUpInside)
        
        button.backgroundColor = .green
        customView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: customView.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
        newProfolioTableView.tableFooterView = customView
    }
    
    @objc func createProfolio() {
        //建立新作品
        
    }
    
    @objc func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func newArea() {
        if selectAreaInTableView.count == 0 && selectedPhotoInTableView.count == 0 {
            selectedPhotoInTableView.append([])
            selectAreaInTableView.append("")
        } else {
            guard let lastArea = selectAreaInTableView.last else { return }
            guard let lastPhotos = selectedPhotoInTableView.last else { return }
            if lastArea == "" || lastPhotos.isEmpty {
                let alertController = UIAlertController(title: "錯誤", message: "請先選擇照片與區域才可新增新的區域", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
            } else {
                selectedPhotoInTableView.append([])
                selectAreaInTableView.append("")
            }
        }
    }
    
    @objc func removeCell(sender: UIButton) {
        guard let cell = sender.superview?.superview as? UploadProfolioTableViewCell else { return }
        guard let indexPath = newProfolioTableView.indexPath(for: cell) else { return }
        selectedPhotoInTableView.remove(at: indexPath.row)
        selectAreaInTableView.remove(at: indexPath.row)
        newProfolioTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        setTableView()
    }
}

extension UploadProfolioViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedPhotoInTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UploadProfolioTableViewCell.self), for: indexPath) as? UploadProfolioTableViewCell else { return UITableViewCell() }
        cell.cellVC = self
        cell.indexPathRow = indexPath.row
        cell.pickerView.tag = indexPath.row
        cell.removeBtn.addTarget(self, action: #selector(removeCell), for: .touchUpInside)
        cell.areaTextField.text = selectAreaInTableView[indexPath.row]
        cell.selectedPhotos = selectedPhotoInTableView[indexPath.row]
        cell.newPhotoCollectionView.reloadData()
        return cell
    }
}

//extension UploadProfolioViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return areaData.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        selectArea[selectArea.count - 1] = areaData[row]
//        newProfolioTableView.reloadData()
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return areaData[row]
//    }
//
//}

//extension UploadProfolioViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return selectedPhotos.count + 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let tableCell = collectionView.superview?.superview as? UploadProfolioTableViewCell else { return UICollectionViewCell() }
//
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PortfolioCollectionViewCell.self), for: indexPath) as? PortfolioCollectionViewCell else { return UICollectionViewCell() }
//        guard let tableCellIndexPath = newProfolioTableView.indexPath(for: tableCell) else {
//            return cell
//        }
//        if indexPath.item == 0 {
//            cell.portfolioImg.contentMode = .scaleAspectFit
//            cell.portfolioImg.image = UIImage.asset(.Icons_24px_AddPhoto)
//        } else {
//            cell.portfolioImg.image = selectedPhotos[indexPath.item - 1]
//        }
//        cell.portfolioImg.backgroundColor = .lightGray
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = CGFloat(floor((collectionView.bounds.width - itemSpace * (columnCount-1)) / columnCount))
//        let height = width
//        return CGSize(width: width, height: height)
//    }
//
//    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
//        return itemSpace
//    }
//
//    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
//        return itemSpace
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
//        guard let photosViewController = storyboard.instantiateViewController(withIdentifier: "PhotosViewController") as? PhotosViewController else { return }
//        photosViewController.parentVC = self
//        present(photosViewController, animated: true, completion: nil)
//    }
//
//}


//
//extension UploadProfolioViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        var selectedImageFromPicker: UIImage?
//
//        // 取得從 UIImagePickerController 選擇的檔案
//        if let pickedImage = info[.originalImage] as? UIImage {
//            selectedImageFromPicker = pickedImage
//        }
//
//        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
//        let uniqueString = NSUUID().uuidString
//
//        // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
//        if let selectedImage = selectedImageFromPicker {
//
//            let storageRef = Storage.storage().reference().child("Profolio").child("\(uniqueString).png")
//
//            if let uploadData = selectedImage.pngData() {
//                // 這行就是 FirebaseStorage 關鍵的存取方法。
//                storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in
//
//                    if error != nil {
//
//                        // 若有接收到錯誤，我們就直接印在 Console 就好，在這邊就不另外做處理。
//                        print("Error: \(error!.localizedDescription)")
//                        return
//                    }
//
//                    //將圖片的URL放到Cloud Firestore
//                    storageRef.downloadURL(completion: { (url, error) in
//
//                    })
//                })
//            }
//        }
//
//        dismiss(animated: true, completion: nil)
//    }
//}
