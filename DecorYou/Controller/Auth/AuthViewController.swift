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
import FacebookLogin

class AuthViewController: UIViewController {
    
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var signInBtn: GIDSignInButton!
    @IBOutlet weak var fbSignInBtn: FBLoginButton!
    var userToken: String?
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func fbSignIn(_ sender: Any) {
        
        let manager = LoginManager()
        manager.logIn(permissions: [.publicProfile], viewController: self) { (result) in
            if case LoginResult.success(granted: _, declined: _, token: _) = result {
                print("login ok")
                let credential =  FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                Auth.auth().signIn(with: credential) { [weak self] (result, error) in
                    guard let self = self else { return }
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    guard let currentToken = AccessToken.current else { return }
                    UserDefaults.standard.set(currentToken.tokenString, forKey: "UserToken")
                    guard let tabVC = self.presentingViewController as? STTabBarViewController else { return }
                    tabVC.selectedIndex = 3
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            } else {
                print("login fail")
            }
        }
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
