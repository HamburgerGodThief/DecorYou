//
//  AuthViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/1/22.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn

class AuthViewController: UIViewController {
    
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var signInBtn: GIDSignInButton!
    var userToken: String?
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func signUp(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        guard let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    @IBAction func logIn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        guard let logInViewController = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as? LogInViewController else { return }
        navigationController?.pushViewController(logInViewController, animated: true)
    }
    
    func setting() {
        signUpBtn.layer.cornerRadius = 15
        logInBtn.layer.cornerRadius = 15
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let image = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        navigationController?.navigationBar.shadowImage = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
    }
}

extension AuthViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                UserDefaults.standard.set(authentication.accessToken, forKey: "UserToken")
                guard let tabVC = self.presentingViewController as? STTabBarViewController else { return }
                tabVC.selectedIndex = 3
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
