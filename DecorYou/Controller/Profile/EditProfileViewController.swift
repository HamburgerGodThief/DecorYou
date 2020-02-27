//
//  EditProfileViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/27.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    var updateTarget: String = ""
    
    @IBAction func touchConfirm(_ sender: Any) {
        
        if textField.text == "" {
            
            let alertController = UIAlertController(title: "錯誤", message: "欄位不可空白", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            
            guard let uid = UserDefaults.standard.string(forKey: "UserToken") else { return }
            
            updataUserData(text: textField.text!)
            
            UserManager.shared.fetchCurrentUser(uid: uid)
            
            guard let tab = presentingViewController as? STTabBarViewController else { return }
            
            guard let navVC = tab.selectedViewController as? UINavigationController else { return }
            
            guard let profileVC = navVC.topViewController as? ProfileViewController else { return }
            
            if updateTarget == "name" {
                
                profileVC.profileNameLabel.text = textField.text
                
            } else {
                
                profileVC.profileEmailLabel.text = textField.text
                
            }
            
            SwiftMes.shared.showSuccessMessage(title: "成功", body: "更改成功", seconds: 1.5)
            
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func touchCancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func updataUserData(text: String) {
        
        guard let uid = UserDefaults.standard.value(forKey: "UserToken") as? String else { return }
        
        if updateTarget == "name" {
            
            UserManager.shared.updateUserName(uid: uid, name: text)
            
        } else {
            
            UserManager.shared.updateUserEmail(uid: uid, email: text)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}
