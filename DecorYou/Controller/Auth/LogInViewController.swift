//
//  LogInViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/3.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInBtn: UIButton!
    
    @IBAction func logIn(_ sender: Any) {
        guard let password = passwordTextField.text, let email = emailTextField.text else {
            
            let alertController = UIAlertController(title: "Error", message: "Name/password can't be empty", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if error == nil {
                let user = Auth.auth().currentUser
                guard let uid = user?.uid else { return }
                UserDefaults.standard.set(uid, forKey: "UserToken")
                UserManager.shared.fetchCurrentUser(uid: uid, completion: { result in
                    switch result {
                        
                    case .success(let user):
                        
                        UserManager.shared.userInfo = user
                        
                        print("Success")
                        
                    case .failure(let error):
                        
                        print(error)
                    }
                })
                guard let tabVC = strongSelf.presentingViewController as? STTabBarViewController else { return }
                tabVC.selectedIndex = 3
                strongSelf.presentingViewController?.dismiss(animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Error", message: "Your email or password is incorrect", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                strongSelf.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func setting() {
        logInBtn.layer.cornerRadius = 15
        emailTextField.addLine(position: LINE_POSITION.LINE_POSITION_BOTTOM, color: .white, width: 3)
        passwordTextField.addLine(position: LINE_POSITION.LINE_POSITION_BOTTOM, color: .white, width: 3)
    }
    
    func setNavigationBar() {
        navigationItem.title = ""
        let btn = UIButton()
        btn.setTitle(" SIGN UP", for: .normal)
        btn.setImage(UIImage.asset(.Icons_24px_Back02), for: .normal)
        btn.tintColor = .white
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        setNavigationBar()
    }
}
