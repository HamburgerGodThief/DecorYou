//
//  AuthenticationViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/26.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit
import Lottie
import Firebase
import GoogleSignIn
import AuthenticationServices

enum AuthViewControllers: String {

    case authenticationViewController = "AuthenticationViewController"

    case identifyViewController = "IdentifyViewController"
    
    case areaViewController = "AreaViewController"
    
    case categoryViewController = "CategoryViewController"
}


class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var googleSignInBtn: UIView!
        
    @IBOutlet weak var appleSignInBtn: UIView!
    
    var appleIDFamilyName: String = ""
    
    var appleIDFirstName: String = ""
    
    var appleIDEmail: String = ""
    
    var appleUID: String = ""
    
    var signInType: String = "Google"
    
    func googleSignInTapGesture() {
        
        let singleFinger = UITapGestureRecognizer(target:self, action:#selector(googleSignIn))

        singleFinger.numberOfTapsRequired = 1

        singleFinger.numberOfTouchesRequired = 1
    
        googleSignInBtn.addGestureRecognizer(singleFinger)
    }
    
    func appleSignInTapGesture() {
        
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleLogInWithAppleIDButtonPress), for: .touchUpInside)
        appleSignInBtn.addSubview(authorizationButton)
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        
        authorizationButton.topAnchor.constraint(equalTo: appleSignInBtn.topAnchor).isActive = true
        authorizationButton.bottomAnchor.constraint(equalTo: appleSignInBtn.bottomAnchor).isActive = true
        authorizationButton.leadingAnchor.constraint(equalTo: appleSignInBtn.leadingAnchor).isActive = true
        authorizationButton.trailingAnchor.constraint(equalTo: appleSignInBtn.trailingAnchor).isActive = true
        
    }
    
    @objc private func handleLogInWithAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
            
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    @objc func googleSignIn() {
        
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "IdentifyVC" {
            
            guard let nav = segue.destination as? UINavigationController else { return }
            
            guard let identifyVC = nav.viewControllers[0] as? IdentifyViewController else { return }
            
            identifyVC.appleIDFamilyName = appleIDFamilyName
            
            identifyVC.appleIDFirstName =  appleIDFirstName
            
            identifyVC.appleIDEmail = appleIDEmail
            
            identifyVC.appleUID = appleUID
            
            identifyVC.signInType = signInType
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleSignInBtn.layer.cornerRadius = googleSignInBtn.frame.height / 2
        googleSignInBtn.layer.borderWidth = 1
        googleSignInBtn.layer.borderColor = UIColor.red.cgColor
        
        appleSignInBtn.layer.cornerRadius = appleSignInBtn.frame.height / 2
        appleSignInBtn.clipsToBounds = true
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        googleSignInTapGesture()
        
        appleSignInTapGesture()
        performExistingAccountSetupFlows()
        
        navigationController?.navigationBar.isHidden = true
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
            
            UserManager.shared.fetchAllUser(completion: { result in
                                
                switch result {
                    
                case.success(let users):
                    
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    
                    let result = users.map({ item -> Bool in
                        if item.uid == uid {
                            return true
                        }
                        return false
                    })
                    
                    if result.contains(true) {
                        
                        guard let tabVC = strongSelf.presentingViewController as? STTabBarViewController else { return }
                        tabVC.selectedIndex = 2
                        strongSelf.dismiss(animated: true, completion: nil)
                        UserManager.shared.fetchCurrentUser(uid: uid)
                        
                    } else {
                        
                        strongSelf.signInType = "Google"
                        
                        strongSelf.performSegue(withIdentifier: "IdentifyVC", sender: nil)
                        
                    }
                    
                case.failure(let error):
                    print(error)
                }
            })
        }
    }
    
}

extension AuthenticationViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    private func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let userFirstName = appleIDCredential.fullName?.givenName
            let userLastName = appleIDCredential.fullName?.familyName
            let userEmail = appleIDCredential.email
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userIdentifier) { [weak self] (credentialState, error) in
                
                guard let strongSelf = self else { return }
                
                switch credentialState {
                    
                case .authorized:
                    // The Apple ID credential is valid. Show Home UI Here
                    strongSelf.appleUID = userIdentifier
                    
                    strongSelf.signInType = "Apple"
                    
                    if userFirstName == nil || userLastName == nil || userEmail == nil {
                        
                        UserManager.shared.fetchCurrentUser(uid: userIdentifier)
                        
                        DispatchQueue.main.async {
                            
                            guard let tabVC = strongSelf.presentingViewController as? STTabBarViewController else { return }
                            
                            tabVC.selectedIndex = 2
                            
                            strongSelf.dismiss(animated: true, completion: nil)
                            
                        }
                        
                    } else {
                        
                        strongSelf.appleIDFamilyName = userLastName!
                        
                        strongSelf.appleIDFirstName =  userFirstName!
                        
                        strongSelf.appleIDEmail = userEmail!
                        
                        DispatchQueue.main.async {
                            
                            strongSelf.performSegue(withIdentifier: "IdentifyVC", sender: nil)
                            
                        }
                        
                    }
                case .revoked:
                    // The Apple ID credential is revoked. Show SignIn UI Here.
                    break
                case .notFound:
                    // No credential was found. Show SignIn UI Here.
                    break
                default:
                    break
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
    
}
