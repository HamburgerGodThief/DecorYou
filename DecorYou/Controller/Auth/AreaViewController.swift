//
//  AreaViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/26.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class AreaViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.delegate = self
            
            collectionView.dataSource = self
            
            collectionView.lk_registerCellWithNib(identifier: "ServiceAreaCollectionViewCell", bundle: nil)
                        
        }
        
    }
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    var categoryType: String = ""
    var selectedCell: [ServiceAreaCollectionViewCell] = []
    let itemSpace: CGFloat = 16
    let columnCount: CGFloat = 3
    let areaData = ["臺北市", "新北市", "基隆市", "桃園市", "新竹縣",
                    "新竹市", "苗栗縣", "臺中市", "南投縣", "彰化縣",
                    "雲林縣", "嘉義縣", "嘉義市", "臺南市", "高雄市",
                    "屏東縣", "宜蘭縣", "花蓮縣", "臺東縣", "澎湖縣",
                    "金門縣", "連江縣"]
    
    var appleIDFamilyName: String = ""
    
    var appleIDFirstName: String = ""
    
    var appleIDEmail: String = ""
    
    var appleUID: String = ""
    
    var signInType: String = ""
    
    func createUserWithGoogle() {
        
        //拿取User存放在Google的資料
        guard let name = Auth.auth().currentUser?.displayName,
            let email = Auth.auth().currentUser?.email,
            let urlString = Auth.auth().currentUser?.photoURL?.absoluteString,
            let uid = Auth.auth().currentUser?.uid else { return }

        //做一個User
        let location = selectedCell.map({ $0.areaLabel.text! })
        
        let newUser = User(uid: uid,
                           email: email,
                           name: name,
                           img: urlString,
                           lovePost: [],
                           selfPost: [],
                           blockUser: [],
                           character: "craftsmen",
                           serviceLocation: location,
                           serviceCategory: categoryType,
                           select: false)
        UserManager.shared.addUserData(uid: uid, user: newUser)
        UserManager.shared.fetchCurrentUser(uid: uid)
        
    }
    
    func createUserWithApple() {
        
        let location = selectedCell.map({ $0.areaLabel.text! })
        //做一個User
        if signInType == "Apple" {
            let newUser = User(uid: appleUID,
                               email: appleIDEmail,
                               name: appleIDFamilyName + appleIDFirstName,
                               lovePost: [],
                               selfPost: [],
                               blockUser: [],
                               character: "craftsmen",
                               serviceLocation: location,
                               serviceCategory: categoryType,
                               select: false)
            UserManager.shared.addUserData(uid: appleUID, user: newUser)
            UserManager.shared.fetchCurrentUser(uid: appleUID)
        }
    }
    
    @IBAction func touchConfirm(_ sender: Any) {
        
        if selectedCell.isEmpty  {
            
            let alertController = UIAlertController(title: "錯誤", message: "服務範圍為必選", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            
            if signInType == "Google" {
                
                createUserWithGoogle()
                
            } else {
                
                createUserWithApple()
                
            }
            
            guard let authVC = presentingViewController as? AuthenticationViewController else { return }
            guard let tabVC = authVC.presentingViewController as? STTabBarViewController else { return }
            tabVC.selectedIndex = 2
            dismiss(animated: false, completion: nil)
            authVC.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func touchBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension AreaViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return areaData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ServiceAreaCollectionViewCell.self), for: indexPath) as? ServiceAreaCollectionViewCell else { return UICollectionViewCell() }
        cell.areaLabel.text = areaData[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - itemSpace * 4) / columnCount
        let height = CGFloat(40)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let left = itemSpace
        let right = itemSpace
        let top = itemSpace
        let bottom = itemSpace
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return itemSpace
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return itemSpace
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ServiceAreaCollectionViewCell else { return }
        if selectedCell.contains(cell) {
            cell.areaLabel.backgroundColor = .clear
            cell.areaLabel.textColor = UIColor.assetColor(.mainColor)
            cell.select = false
            guard let index = selectedCell.firstIndex(of: cell) else { return }
            selectedCell.remove(at: index)
        } else {
            selectedCell.append(cell)
            cell.areaLabel.backgroundColor = UIColor.assetColor(.mainColor)
            cell.areaLabel.textColor = .white
            cell.select = true
            if selectedCell.count > 2 {
                selectedCell.first?.areaLabel.backgroundColor = .clear
                selectedCell.first?.areaLabel.textColor = UIColor.assetColor(.mainColor)
                selectedCell.first?.select = false
                selectedCell.removeFirst()
            }
        }
    }
}
