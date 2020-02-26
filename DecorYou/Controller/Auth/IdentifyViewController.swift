//
//  IdentifyViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/26.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class IdentifyViewController: UIViewController {

    @IBOutlet weak var customerStackView: UIStackView!
    @IBOutlet weak var craftsmenStackView: UIStackView!
    
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
    

    @objc func popToCustomer() {
        UserDefaults.standard.set("customer", forKey: "UserCharacter")
        
        
    }
    
    @objc func popToCraftsmen() {
        
        UserDefaults.standard.set("craftsmen", forKey: "UserCharacter")
        let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
        guard let categoryVC = storyboard.instantiateViewController(identifier: AuthViewControllers.categoryViewController.rawValue) as? CategoryViewController else { return }
        navigationController?.pushViewController(categoryVC, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customerViewAddTapGesture()
        craftsmenViewAddTapGesture()
    }

}
