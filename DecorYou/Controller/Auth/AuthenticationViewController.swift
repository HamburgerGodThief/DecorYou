//
//  AuthenticationViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/26.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

enum AuthViewControllers: String {

    case authenticationViewController = "AuthenticationViewController"

    case identifyViewController = "IdentifyViewController"
    
    case areaViewController = "AreaViewController"
    
    case categoryViewController = "CategoryViewController"
}


class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var googleSignInBtn: UIView!
    
    func googleSignInTapGesture() {
        
        let singleFinger = UITapGestureRecognizer(target:self, action:#selector(googleSignIn))

        singleFinger.numberOfTapsRequired = 1

        singleFinger.numberOfTouchesRequired = 1
    
        googleSignInBtn.addGestureRecognizer(singleFinger)
    }
    

    @objc func googleSignIn() {
        
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        googleSignInTapGesture()
    }

}

extension AuthenticationViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        //登入失敗
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        //登入成功
        guard let authentication = user.authentication else { return }
        
        let googleCredential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: googleCredential) { [weak self] (result, error) in
            
            guard let strongSelf = self else { return }
            if let error = error {
                print(error.localizedDescription)
            }
            
//            //拿取User存放在Google的資料
//            guard let name = Auth.auth().currentUser?.displayName,
//                let email = Auth.auth().currentUser?.email,
//                let urlString = Auth.auth().currentUser?.photoURL?.absoluteString,
//                let uid = Auth.auth().currentUser?.uid else { return }
//
//            //做一個User
//            let newUser = User(uid: uid,
//                               email: email,
//                               name: name,
//                               img: urlString,
//                               lovePost: [],
//                               selfPost: [],
//                               character: "customer",
//                               serviceLocation: [],
//                               serviceCategory: "",
//                               select: false)
//            UserManager.shared.addUserData(uid: uid, user: newUser)
                        
            let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
            guard let identifyVC = storyboard.instantiateViewController(identifier: AuthViewControllers.identifyViewController.rawValue) as? IdentifyViewController else { return }
            identifyVC.modalPresentationStyle = .overFullScreen
            strongSelf.present(identifyVC, animated: true, completion: nil)
            
        }
    }
    
}
