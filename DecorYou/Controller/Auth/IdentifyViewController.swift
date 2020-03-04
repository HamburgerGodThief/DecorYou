//
//  IdentifyViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/26.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit
import Firebase

class IdentifyViewController: UIViewController {

    @IBOutlet weak var customerStackView: UIStackView!
    @IBOutlet weak var craftsmenStackView: UIStackView!
    
    var appleIDFamilyName: String = ""
    
    var appleIDFirstName: String = ""
    
    var appleIDEmail: String = ""
    
    var appleUID: String = ""
    
    var signInType: String = ""
    
    func customerViewAddTapGesture() {
        
        let singleFinger = UITapGestureRecognizer(target:self, action:#selector(popToCustomer))

        singleFinger.numberOfTapsRequired = 1

        singleFinger.numberOfTouchesRequired = 1
    
        customerStackView.addGestureRecognizer(singleFinger)
    }
    
    func craftsmenViewAddTapGesture() {
        
        let singleFinger = UITapGestureRecognizer(target:self, action:#selector(popToCraftsmen))

        singleFinger.numberOfTapsRequired = 1

        singleFinger.numberOfTouchesRequired = 1
    
        craftsmenStackView.addGestureRecognizer(singleFinger)
    }
    
    func createUserWithGoogle() {
        
        //拿取User存放在Google的資料
        guard let name = Auth.auth().currentUser?.displayName,
            let email = Auth.auth().currentUser?.email,
            let urlString = Auth.auth().currentUser?.photoURL?.absoluteString,
            let uid = Auth.auth().currentUser?.uid else { return }

        //做一個User
        let newUser = User(uid: uid,
                           email: email,
                           name: name,
                           img: urlString,
                           lovePost: [],
                           selfPost: [],
                           blockUser: [],
                           character: "customer",
                           serviceLocation: [],
                           serviceCategory: "",
                           select: false)
        UserManager.shared.addUserData(uid: uid, user: newUser)
        UserManager.shared.fetchCurrentUser(uid: uid)
    }
    
    func createUserWithApple() {

        //做一個User
        let newUser = User(uid: appleUID,
                           email: appleIDEmail,
                           name: appleIDFamilyName + appleIDFirstName,
                           lovePost: [],
                           selfPost: [],
                           blockUser: [],
                           character: "customer",
                           serviceLocation: [],
                           serviceCategory: "",
                           select: false)
        UserManager.shared.addUserData(uid: appleUID, user: newUser)
        UserManager.shared.fetchCurrentUser(uid: appleUID)
        
    }
    
    
    @objc func popToCustomer() {
        
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
    
    @objc func popToCraftsmen() {
        
        let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
        guard let categoryVC = storyboard.instantiateViewController(identifier: AuthViewControllers.categoryViewController.rawValue) as? CategoryViewController else { return }
        
        categoryVC.appleIDFamilyName = appleIDFamilyName
        
        categoryVC.appleIDFirstName = appleIDFirstName
        
        categoryVC.appleIDEmail = appleIDEmail
        
        categoryVC.appleUID = appleUID
        
        categoryVC.signInType = signInType
        
        navigationController?.pushViewController(categoryVC, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customerViewAddTapGesture()
        craftsmenViewAddTapGesture()
        navigationController?.navigationBar.isHidden = true
    }

}
