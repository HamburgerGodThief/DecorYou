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
                image: UIImage.asset(.Icons_36px_NewsFeed_Normal),
                selectedImage: UIImage.asset(.Icons_36px_NewsFeed_Selected)
            )
            
        case .craftsmen:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Tool_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Tool_Selected)
            )
            
        case .chat:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Chat_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Chat_Selected)
            )
            
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
    
    private let tabs: [Tab] = [.article, .craftsmen, .chat, .profile]
    
    var chatTabBarItem: UITabBarItem!
    
    var orderObserver: NSKeyValueObservation!
    
    var filterView: FilterView = UINib(nibName: "FilterView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! FilterView
    
    var isExpand: Bool = false
    
    var statusBarHidden = true {
        
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return statusBarHidden
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = tabs.map({ $0.controller() })
        
        chatTabBarItem = viewControllers?[2].tabBarItem
        
        chatTabBarItem.badgeColor = .brown
        
        delegate = self
        
        configureFilterView()
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let navVC = viewController as? UINavigationController,
            navVC.viewControllers.first is ProfileViewController
            else { return true }
        
        let userToken = UserDefaults.standard.value(forKey: "UserToken")
        
        guard userToken != nil else {

            if let authVC = UIStoryboard.auth.instantiateInitialViewController() {

                authVC.modalPresentationStyle = .overCurrentContext
                
                present(authVC, animated: false, completion: nil)
            }
            
            return false
        }
        
        return true
    }
    
    func configureFilterView() {
        filterView.frame.origin.x = -self.view.frame.width
        filterView.isHidden = true
        
        let singleFinger = UITapGestureRecognizer(target:self, action:#selector(singleTap))

        singleFinger.numberOfTapsRequired = 1

        singleFinger.numberOfTouchesRequired = 1

        filterView.transparentView.addGestureRecognizer(singleFinger)
        
        view.addSubview(filterView)
    }
    
    @objc func singleTap() {
//        statusBarHidden = false
        UIView.animate(withDuration: 0.6, delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.filterView.frame.origin.x = -self.view.frame.width
        }, completion: nil)
    }
    
    func showFilter() {
        filterView.isHidden = false
//        statusBarHidden = true
        //show filter
        UIView.animate(withDuration: 0.6, delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.filterView.frame.origin.x = 0
        }, completion: nil)
    }
    
}
