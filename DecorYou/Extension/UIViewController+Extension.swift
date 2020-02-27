//
//  UIViewController+Extension.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/25.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentLoadingVC() {
        
        let loadingVC = LoadingViewController()
        
        loadingVC.modalPresentationStyle = .overFullScreen
        
        loadingVC.modalTransitionStyle = .crossDissolve
        
        present(loadingVC, animated: true, completion: nil)
        
    }
}