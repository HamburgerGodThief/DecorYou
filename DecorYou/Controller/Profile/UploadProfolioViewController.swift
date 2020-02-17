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
    let tableFooterView = UINib(nibName: "UploadProfolioTableFooterView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UploadProfolioTableFooterView
    var selectedPhotoInTableView: [[UIImage]] = [] {
        didSet {
            newProfolioTableView.reloadData()
        }
    }
    var selectedPhotos: [UIImage] = [] {
        didSet {
            selectedPhotoInTableView[selectedPhotoInTableView.count - 1] = selectedPhotos
//            selectedPhotoInTableView.append(selectedPhotos)
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
    
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func createProfolio() {
        //建立新作品
        
        
        
    }
    
    @objc func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func newArea() {
        selectedPhotoInTableView.append([])
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
        cell.selectedPhotos = selectedPhotoInTableView[indexPath.row]
        cell.cellVC = self
        cell.newPhotoCollectionView.reloadData()
        return cell
    }
}

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
