//
//  PickCraftsmenViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/13.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit
import Firebase

class PickCraftsmenViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var serviceCategoryTextField: UITextField!
    @IBOutlet weak var serviceAreaTextField: UITextField!
    @IBOutlet weak var signUPBtn: UIButton!
    
    func setIBOutlet() {
        signUPBtn.layer.cornerRadius = 15
        nameTextField.addLine(position: LINE_POSITION.LINE_POSITION_BOTTOM, color: .white, width: 3)
        emailTextField.addLine(position: LINE_POSITION.LINE_POSITION_BOTTOM, color: .white, width: 3)
        passwordTextField.addLine(position: LINE_POSITION.LINE_POSITION_BOTTOM, color: .white, width: 3)
        serviceCategoryTextField.addLine(position: LINE_POSITION.LINE_POSITION_BOTTOM, color: .white, width: 3)
        serviceAreaTextField.addLine(position: LINE_POSITION.LINE_POSITION_BOTTOM, color: .white, width: 3)
    }
    
    @IBAction func didTouchSignUp(_ sender: Any) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text,
            let serviceCategory = serviceCategoryTextField.text else {
            
            let alertController = UIAlertController(title: "Error", message: "Input can't be empty", preferredStyle: .alert)
            
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
                    let craftman = Craftsmen(email: email,
                                             name: name,
                                             uid: uid,
                                             lovePost: [],
                                             selfPost: [],
                                             character: "craftsmen",
                                             serviceLocation: ["ss", "asdf"],
                                             serviceCategory: serviceCategory)
                    UserManager.shared.addCraftsmanData(uid: uid, craftman: craftman)
                    UserManager.shared.fetchCurrentCraftsmen(uid: uid, completion: { result in
                        switch result {
                            
                        case .success(let craftsmen):
                            
                            UserManager.shared.craftsmenInfo = craftsmen
                        
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
    
    func setNavigationBar() {
        navigationItem.title = ""
        let btn = UIButton()
        btn.setTitle(" Who You Are", for: .normal)
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
        setIBOutlet()
        setNavigationBar()
        // Do any additional setup after loading the view.
    }
}
