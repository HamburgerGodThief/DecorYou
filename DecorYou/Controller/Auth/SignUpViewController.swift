//
//  SignUpViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/3.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBAction func signUp(_ sender: Any) {
        guard let tabVC = self.presentingViewController as? STTabBarViewController else { return }
        tabVC.selectedIndex = 3
        presentingViewController?.dismiss(animated: true, completion: nil)
        
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
