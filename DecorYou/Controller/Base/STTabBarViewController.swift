//
//  ViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/1/22.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

private enum Tab {
    
    case article
    
    case craftsmen
    
    case chat
    
    case profile
    
    func controller() -> UIViewController {
        
        var controller: UIViewController
        
        switch self {
            
        case .article: controller = UIStoryboard.article.instantiateInitialViewController()!
            
        case .craftsmen: controller = UIStoryboard.craftsmen.instantiateInitialViewController()!
            
        case .chat: controller = UIStoryboard.chat.instantiateInitialViewController()!
            
        case .profile: controller = UIStoryboard.profile.instantiateInitialViewController()!
            
        }
        
        controller.tabBarItem = tabBarItem()
        
        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)
        
        return controller
    }
    
    func tabBarItem() -> UITabBarItem {
        
        switch self {
            
        case .article:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Home_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Home_Selected)
            )
            
        case .craftsmen:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Catalog_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Catalog_Selected)
            )
            
        case .chat:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Cart_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Cart_Selected)
            )
            
        case .profile:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Cart_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Cart_Selected)
            )
            
        }
    }
}


class STTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    private let tabs: [Tab] = [.article, .craftsmen, .chat, .profile]
    
    var trolleyTabBarItem: UITabBarItem!
    
    var orderObserver: NSKeyValueObservation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = tabs.map({ $0.controller() })
        
        //trolleyTabBarItem = viewControllers?[2].tabBarItem
        
        //trolleyTabBarItem.badgeColor = .brown
        
        delegate = self
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let navVC = viewController as? UINavigationController,
            navVC.viewControllers.first is ProfileViewController
            else { return true }
        
        let userToken = UserDefaults.standard.value(forKey: "UserToken")
        
        guard userToken != nil else {
            //        guard KeyChainManager.shared.token != nil else {
            
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            if let loginVC = storyboard.instantiateViewController(identifier: "Auth") as? AuthViewController {
                loginVC.modalPresentationStyle = .overFullScreen
                present(loginVC, animated: false, completion: nil)
                
                if let authVC = UIStoryboard.auth.instantiateInitialViewController() {
                    
                    authVC.modalPresentationStyle = .overCurrentContext
                    
                    present(authVC, animated: false, completion: nil)
                }
            }
            return false
        }
        
        return true
    }
}
