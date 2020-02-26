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
//import GoogleSignIn

class AuthViewController: UIViewController {
    
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var logInBtn: UIButton!
    var userToken: String?
    
    @IBAction func signUp(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        guard let characterPickViewController = storyboard.instantiateViewController(withIdentifier: "CharacterPickViewController") as? CharacterPickViewController else { return }
        navigationController?.pushViewController(characterPickViewController, animated: true)
    }
    
    @IBAction func logIn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthenticationViewController") as? AuthenticationViewController else { return }
        navigationController?.pushViewController(authViewController, animated: true)
//        guard let logInViewController = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as? LogInViewController else { return }
//        navigationController?.pushViewController(logInViewController, animated: true)
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
    }
}
