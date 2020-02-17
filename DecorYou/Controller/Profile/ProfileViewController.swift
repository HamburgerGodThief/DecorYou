//
//  ProfileViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/1/22.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase

class FuncTable {
    let name: String
    let img: UIImage?
    
    init(name: String, img: UIImage?) {
        self.name = name
        self.img = img
    }
}

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var shadowView: RoundCornerAndShadow!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var lovePost: UILabel!
    @IBOutlet weak var cameraBtn: UIButton!
    let userFunction: [FuncTable] = [
        FuncTable(name: "個人資訊", img: UIImage.asset(.Icons_24px_UserInfo)),
        FuncTable(name: "收藏文章", img: UIImage(systemName: "heart")),
        FuncTable(name: "你的文章", img: UIImage(systemName: "doc.text")),
        FuncTable(name: "登出", img: UIImage.asset(.Icons_24px_LogOut))
    ]
    let craftsmenFunction: [FuncTable] = [FuncTable(name: "個人資訊", img: UIImage.asset(.Icons_24px_UserInfo)),
                                          FuncTable(name: "履歷與作品集", img: UIImage.asset(.Icons_24px_Profolio)),
                                          FuncTable(name: "收藏文章", img: UIImage(systemName: "heart")),
                                          FuncTable(name: "你的文章", img: UIImage(systemName: "doc.text")),
                                          FuncTable(name: "登出", img: UIImage.asset(.Icons_24px_LogOut))]
    var finalFunction: [FuncTable] = []
    
    let withIdentifier = ["InfoViewController", "FavoriteViewController", "YourPostViewController"]
    
    func setNavigationBar() {
        navigationItem.title = "個人頁面"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white,
                                                                   .font: UIFont(name: "PingFangTC-Medium", size: 18)!]
        navigationController?.navigationBar.barTintColor = UIColor.assetColor(.mainColor)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
    }
    
    func setTableView() {
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.lk_registerCellWithNib(identifier: String(describing: ProfileTableViewCell.self), bundle: nil)
        profileTableView.separatorStyle = .none
        profileTableView.bounces = false
        shadowView.layoutTableView(profileTableView, radius: 10, color: .black, offset: CGSize(width: 10, height: 10), opacity: 0.8, cornerRadius: 60)
    }
    
    func setIBOutlet() {
        logoImg.layer.cornerRadius = logoImg.frame.width / 2
        logoImg.layer.borderWidth = 5
        logoImg.layer.borderColor = UIColor.white.cgColor
        cameraBtn.layer.cornerRadius = cameraBtn.frame.width / 2
        cameraBtn.layer.borderWidth = 2
        cameraBtn.layer.borderColor = UIColor.white.cgColor
    }
    
    func getUserInfo() {
        guard let uid = UserDefaults.standard.string(forKey: "UserToken") else { return }
        UserManager.shared.fetchCurrentUser(uid: uid)
        guard let user = UserManager.shared.user else { return }
        logoImg.loadImage(user.img, placeHolder: UIImage())
        postLabel.text = "\(user.selfPost.count)"
        lovePost.text = "\(user.lovePost.count)"
        
        if user.character == "customer" {
            finalFunction = userFunction
        } else {
            finalFunction = craftsmenFunction
        }
        profileTableView.reloadData()
    }
    
    func customerCellDidSelect(indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        var nextVC: UIViewController?
        switch indexPath.row {
        case 0:
            nextVC = storyboard.instantiateViewController(withIdentifier: "InfoViewController") as? InfoViewController
        case 1:
            nextVC = storyboard.instantiateViewController(withIdentifier: "FavoriteViewController") as? FavoriteViewController
        case 2:
            nextVC = storyboard.instantiateViewController(withIdentifier: "YourPostViewController") as? YourPostViewController
        default:
            UserDefaults.standard.set(nil, forKey: "UserToken")
            UserDefaults.standard.set(nil, forKey: "UserCharacter")
            UserManager.shared.user = nil
            let alertController = UIAlertController(title: "成功登出", message: "你已成功登出", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action: UIAlertAction!) -> Void in
                guard let strongSelf = self else { return }
                guard let tabVC = strongSelf.presentingViewController as? STTabBarViewController else { return }
                tabVC.selectedIndex = 0
            })
            
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
        guard let nvc = nextVC else { return }
        navigationController?.pushViewController(nvc, animated: true)
    }
    
    func craftsmenCellDidSelect(indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        var nextVC: UIViewController?
        switch indexPath.row {
        case 0:
            nextVC = storyboard.instantiateViewController(withIdentifier: "InfoViewController") as? InfoViewController
        case 1:
            nextVC = storyboard.instantiateViewController(withIdentifier: "CraftsmenResumeViewController") as? CraftsmenResumeViewController
        case 2:
            nextVC = storyboard.instantiateViewController(withIdentifier: "FavoriteViewController") as? FavoriteViewController
        case 3:
            nextVC = storyboard.instantiateViewController(withIdentifier: "YourPostViewController") as? YourPostViewController
        default:
            UserDefaults.standard.set(nil, forKey: "UserToken")
            UserDefaults.standard.set(nil, forKey: "UserCharacter")
            UserManager.shared.user = nil
            let alertController = UIAlertController(title: "成功登出", message: "你已成功登出", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action: UIAlertAction!) -> Void in
                guard let strongSelf = self else { return }
                strongSelf.tabBarController?.selectedIndex = 0
            })
            
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
        guard let nvc = nextVC else { return }
        navigationController?.pushViewController(nvc, animated: true)
    }
    
    @IBAction func changeImg(_ sender: Any) {
        
        // 建立一個 UIImagePickerController 的實體
        let imagePickerController = UIImagePickerController()
        
        // 委任代理
        imagePickerController.delegate = self
        
        // 建立一個 UIAlertController 的實體
        // 設定 UIAlertController 的標題與樣式為 動作清單 (actionSheet)
        let imagePickerAlertController = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)
        
        // 建立三個 UIAlertAction 的實體
        // 新增 UIAlertAction 在 UIAlertController actionSheet 的 動作 (action) 與標題
        
        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (Void) in
            
            // 判斷是否可以從照片圖庫取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.photoLibrary)，並 present UIImagePickerController
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { (Void) in
            
            // 判斷是否可以從相機取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.camera)，並 present UIImagePickerController
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        
        // 新增一個取消動作，讓使用者可以跳出 UIAlertController
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (Void) in
            imagePickerAlertController.dismiss(animated: true, completion: nil)
        }
        
        // 將上面三個 UIAlertAction 動作加入 UIAlertController
        imagePickerAlertController.addAction(imageFromLibAction)
        imagePickerAlertController.addAction(imageFromCameraAction)
        imagePickerAlertController.addAction(cancelAction)
        
        // 當使用者按下 uploadBtnAction 時會 present 剛剛建立好的三個 UIAlertAction 動作與
        present(imagePickerAlertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setTableView()
        setIBOutlet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserInfo()
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(finalFunction.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalFunction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileTableViewCell.self), for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        cell.functionLabel.text = finalFunction[indexPath.row].name
        cell.iconImg.image = finalFunction[indexPath.row].img
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = UserManager.shared.user else { return }
        if user.character == "customer" {
            customerCellDidSelect(indexPath: indexPath)
        } else {
            craftsmenCellDidSelect(indexPath: indexPath)
        }
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
            
            let storageRef = Storage.storage().reference().child("AppCodaFireUpload").child("\(uniqueString).png")
            
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
                        UserManager.shared.updateUserImage(uid: user.uid, img: imgURL)
                        strongSelf.logoImg.loadImage(imgURL)
                        
                        strongSelf.dismiss(animated: true, completion: nil)
                    })
                })
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}
