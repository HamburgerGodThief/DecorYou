//
//  SizeViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/8.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class SizeViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var sizeTextField: UITextField!
    
    @IBAction func didTouchConfirm(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.layer.cornerRadius = 20
        topView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        topView.layer.borderColor = UIColor.lightGray.cgColor
        topView.layer.borderWidth = 1
    }

}
