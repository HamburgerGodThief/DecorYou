//
//  ProfileViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/24.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var yourPostContainerView: UIView!
    @IBOutlet weak var favoritePostContainerView: UIView!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var coverBackgroundView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.delegate = self
            collectionView.dataSource = self
            
        }
        
    }
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    var yourPostVC: YourPostViewController!
    var favoriteVC: FavoriteViewController!
    var user: User?
    let customerTabTitle: [String] = ["你的文章", "收藏文章"]
    let craftsmenTabTitle: [String] = ["你的文章", "收藏文章", "作品集"]
    var finalTabTitle: [String] = []
    var selectStatus: [Bool] = []
    let indicator = UIView()
    var editType: Bool = true
    
    @IBAction func didTouchEditBtn(_ sender: Any) {
        
        //IImagePickerController 的實體
        let imagePickerController = UIImagePickerController()
        
        // 委任代理
        imagePickerController.delegate = self
        
        let editPickerAlertController = UIAlertController(title: "編輯圖片", message: "請選擇要編輯區域的圖片", preferredStyle: .actionSheet)

        // 建立三個 UIAlertAction 的實體
        // 新增 UIAlertAction 在 UIAlertController actionSheet 的 動作 (action) 與標題

        let imageForProfileImgAction = UIAlertAction(title: "個人大頭貼", style: .default) { [weak self] (Void) in

            // 判斷是否可以從照片圖庫取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {

                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.photoLibrary)，並 present UIImagePickerController
                imagePickerController.sourceType = .photoLibrary
                self?.editType = true
                self?.present(imagePickerController, animated: true, completion: nil)
            }
        }
        
        let imageForBackImgAction = UIAlertAction(title: "背景照片", style: .default) { [weak self] (Void) in

            // 判斷是否可以從照片圖庫取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePickerController.sourceType = .photoLibrary
                self?.editType = false
                self?.present(imagePickerController, animated: true, completion: nil)
            }
        }
        
        // 新增一個取消動作，讓使用者可以跳出 UIAlertController
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (Void) in
            editPickerAlertController.dismiss(animated: true, completion: nil)
        }

        // 將上面三個 UIAlertAction 動作加入 UIAlertController
        editPickerAlertController.addAction(imageForProfileImgAction)
        editPickerAlertController.addAction(imageForBackImgAction)
        editPickerAlertController.addAction(cancelAction)

        // 當使用者按下 uploadBtnAction 時會 present 剛剛建立好的三個 UIAlertAction 動作與
        present(editPickerAlertController, animated: true, completion: nil)

    }
    
    @IBAction func didTouchLogOut(_ sender: Any) {
        
        let alertController = UIAlertController(title: "登出", message: "確認要登出了嗎？", preferredStyle: .alert)

        // 建立[取消]按鈕
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        // 建立[送出]按鈕
        let okAction = UIAlertAction(title: "確定", style: .default, handler: {
            [weak self] (action: UIAlertAction!) -> Void in
            guard let strongSelf = self else { return }
            UserDefaults.standard.set(nil, forKey: "UserToken")
            UserDefaults.standard.set(nil, forKey: "UserCharacter")
            UserManager.shared.user = nil
            strongSelf.tabBarController?.selectedIndex = 0
        })
        alertController.addAction(okAction)

        // 顯示提示框
        present(alertController, animated: true, completion: nil)
    }

    func setIBOutlet() {
        coverBackgroundView.layer.cornerRadius = coverBackgroundView.frame.width / 2
        profileImg.layer.cornerRadius = profileImg.frame.width / 2
    }
    
    func indicatorUnderCollection() {
        let lightGrayIndicator = UIView()
        lightGrayIndicator.backgroundColor = .lightGray
        view.addSubview(lightGrayIndicator)
        lightGrayIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: lightGrayIndicator, attribute: .width, relatedBy: .equal, toItem: collectionView, attribute: .width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: lightGrayIndicator, attribute: .height, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0, constant: 1),
            NSLayoutConstraint(item: lightGrayIndicator, attribute: .bottom, relatedBy: .equal, toItem: collectionView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: lightGrayIndicator, attribute: .leading, relatedBy: .equal, toItem: collectionView, attribute: .leading, multiplier: 1, constant: 0)
        ])
        
        indicator.backgroundColor = .black
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: indicator, attribute: .width, relatedBy: .equal, toItem: collectionView, attribute: .width, multiplier: 1 / CGFloat(finalTabTitle.count), constant: 0),
            NSLayoutConstraint(item: indicator, attribute: .height, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0, constant: 3),
            NSLayoutConstraint(item: indicator, attribute: .bottom, relatedBy: .equal, toItem: collectionView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: indicator, attribute: .leading, relatedBy: .equal, toItem: collectionView, attribute: .leading, multiplier: 1, constant: 0)
        ])
    }
    
    func getUserInfo() {
        guard let user = UserManager.shared.user else { return }
        profileImg.loadImage(user.img, placeHolder: UIImage())
        profileNameLabel.text = user.name
        if user.character == "craftsmen" {
            finalTabTitle = craftsmenTabTitle
            selectStatus = [true, false, false]
        } else {
            finalTabTitle = customerTabTitle
            selectStatus = [true, false]
        }
        indicatorUnderCollection()
        whichVCShouldShow(index: 0)
        collectionView.reloadData()
    }
    
    func whichVCShouldShow(index: Int) {
        
        if index == 0 {
            
            yourPostContainerView.alpha = 1
            
            favoritePostContainerView.alpha = 0
            
        } else if index == 1 {
            
            yourPostContainerView.alpha = 0
            
            favoritePostContainerView.alpha = 1
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setIBOutlet()
        
        getUserInfo()
        
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.barStyle = .black
        
    }
    
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return finalTabTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProfileCollectionViewCell.self), for: indexPath) as? ProfileCollectionViewCell else { return UICollectionViewCell() }
        
        cell.tabTitleLabel.text = finalTabTitle[indexPath.item]

        cell.tabTitleLabel.textColor = selectStatus[indexPath.item] ? .black : .lightGray
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(floor((collectionView.bounds.width / CGFloat(finalTabTitle.count))))
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for index in 0..<selectStatus.count {
            selectStatus[index] = false
        }
        selectStatus[indexPath.item] = true
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.indicator.frame.origin.x = strongSelf.collectionView.frame.size.width * CGFloat(Double(indexPath.item) / Double(strongSelf.selectStatus.count))
            
            strongSelf.whichVCShouldShow(index: indexPath.item)
            
        }, completion: nil)
                
        collectionView.reloadData()
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        var selectedImageFromPicker: UIImage?

        // 取得從 UIImagePickerController 選擇的檔案
        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = pickedImage
        }

        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
        let uniqueString = NSUUID().uuidString

        // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
        if let selectedImage = selectedImageFromPicker {

            let storageRef = Storage.storage().reference().child("ProfileUpload").child("\(uniqueString).png")

            if let uploadData = selectedImage.pngData() {
                // 這行就是 FirebaseStorage 關鍵的存取方法。
                storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in

                    if error != nil {

                        // 若有接收到錯誤，我們就直接印在 Console 就好，在這邊就不另外做處理。
                        print("Error: \(error!.localizedDescription)")
                        return
                    }

                    //將圖片的URL放到Cloud Firestore
                    storageRef.downloadURL(completion: { [weak self] (url, error) in
                        guard let strongSelf = self else { return }
                        guard let imgURL = url?.absoluteString else { return }
                        guard let user = UserManager.shared.user else { return }
                        if strongSelf.editType {
                            
                            UserManager.shared.updateUserImage(uid: user.uid, img: imgURL)
                            strongSelf.profileImg.loadImage(imgURL)
                            
                        } else {
                            
                        }
                        
                        
                        strongSelf.dismiss(animated: true, completion: nil)
                    })
                })
            }
        }

        dismiss(animated: true, completion: nil)
    }
}

