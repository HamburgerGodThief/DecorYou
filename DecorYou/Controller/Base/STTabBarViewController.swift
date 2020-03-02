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
    
//    case chat
    
    case profile
    
    func controller() -> UIViewController {
        
        var controller: UIViewController
        
        switch self {
            
        case .article: controller = UIStoryboard.article.instantiateInitialViewController()!
            
        case .craftsmen: controller = UIStoryboard.craftsmen.instantiateInitialViewController()!
            
//        case .chat: controller = UIStoryboard.chat.instantiateInitialViewController()!
            
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
                image: UIImage.asset(.Icons_36px_NewsFeed_Normal),
                selectedImage: UIImage.asset(.Icons_36px_NewsFeed_Selected)
            )
            
        case .craftsmen:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Tool_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Tool_Selected)
            )
            
//        case .chat:
//            return UITabBarItem(
//                title: nil,
//                image: UIImage.asset(.Icons_36px_Chat_Normal),
//                selectedImage: UIImage.asset(.Icons_36px_Chat_Selected)
//            )
            
        case .profile:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Account_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Account_Selected)
            )
            
        }
    }
}


class STTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
//    private let tabs: [Tab] = [.article, .craftsmen, .chat, .profile]
    private let tabs: [Tab] = [.article, .craftsmen, .profile]
    
//    var chatTabBarItem: UITabBarItem!
    
    var orderObserver: NSKeyValueObservation!
    
    var filterVC: FilterViewController!
    
    var craftsmenFilterVC: CraftsmenFilterViewController!
    
    var isExpand: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = tabs.map({ $0.controller() })
        
//        chatTabBarItem = viewControllers?[2].tabBarItem
//
//        chatTabBarItem.badgeColor = .brown
        
        delegate = self
        
        configureFilterVC()
        
        configureCraftsmenFilterVC()
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //當User點擊到個人頁面時，檢查Token，沒有就跳出登入頁面
        guard let navVC = viewController as? UINavigationController,
            navVC.viewControllers.first is ProfileViewController
            else { return true }
        
        let userToken = UserDefaults.standard.value(forKey: "UserToken") as? String
        
        guard userToken != nil else {

            if let authVC = UIStoryboard.auth.instantiateInitialViewController() {

                authVC.modalPresentationStyle = .overCurrentContext
                
                present(authVC, animated: false, completion: nil)
            }
            
            return false
        }
        
        UserManager.shared.fetchCurrentUser(uid: userToken!)
        
        return true
    }
    
    func configureFilterVC() {
        if filterVC == nil {
            let storyboard = UIStoryboard(name: "Article", bundle: nil)
            filterVC = storyboard.instantiateViewController(identifier: "FilterViewController") as? FilterViewController
        }
        filterVC.modalPresentationStyle = .overFullScreen
    }
    
    func configureCraftsmenFilterVC() {
        if craftsmenFilterVC == nil {
            let storyboard = UIStoryboard(name: "Craftsmen", bundle: nil)
            craftsmenFilterVC = storyboard.instantiateViewController(identifier: "CraftsmenFilterViewController") as? CraftsmenFilterViewController
        }
        craftsmenFilterVC.modalPresentationStyle = .overFullScreen
    }
    
}
