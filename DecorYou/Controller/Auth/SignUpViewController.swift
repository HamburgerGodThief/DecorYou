//
//  SignUpViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/3.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var characterSegmentControl: UISegmentedControl!
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBAction func signUp(_ sender: Any) {
        guard let character = characterSegmentControl.titleForSegment(at: characterSegmentControl.selectedSegmentIndex) else { return }
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = userNameTextField.text else {
            
            let alertController = UIAlertController(title: "Error", message: "Name/email/password can't be empty", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error == nil {
                print("成功")
                
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                    guard let strongSelf = self else { return }
                    let user = Auth.auth().currentUser
                    guard let uid = user?.uid else { return }
                    UserDefaults.standard.set(uid, forKey: "UserToken")
                    UserManager.shared.addUserData(name: name, uid: uid, email: email, lovePost: [], selfPost: [], character: character)
                    UserManager.shared.fetchCurrentUser(uid: uid, completion: { result in
                        switch result {
                            
                        case .success(let user):
                            
                            UserManager.shared.userInfo = user
                        
                        case .failure(let error):
                            
                            print(error)
                        }
                    })
                    guard let tabVC = strongSelf.presentingViewController as? STTabBarViewController else { return }
                    tabVC.selectedIndex = 3
                    strongSelf.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            } else {
                let alertController = UIAlertController(title: "Error", message: "This email already signed up.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func setting() {
        signUpBtn.layer.cornerRadius = 15
        userNameTextField.addLine(position: LINE_POSITION.LINE_POSITION_BOTTOM, color: .white, width: 3)
        emailTextField.addLine(position: LINE_POSITION.LINE_POSITION_BOTTOM, color: .white, width: 3)
        passwordTextField.addLine(position: LINE_POSITION.LINE_POSITION_BOTTOM, color: .white, width: 3)
    }
    
    func setNavigationBar() {
        navigationItem.title = ""
        let btn = UIButton()
        btn.setTitle(" LOG IN", for: .normal)
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
