//
//  SizeViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/8.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

protocol SizeViewControllerDelegate: AnyObject {
    
    func passDataToParentVC(_ sizeViewController: SizeViewController)
    
}

class SizeViewController: UIViewController {
    
    weak var delegate: SizeViewControllerDelegate?
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var sizeTextField: UITextField!
    
    @IBAction func didTouchConfirm(_ sender: Any) {
        delegate?.passDataToParentVC(self)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.layer.cornerRadius = 20
        topView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        topView.layer.borderColor = UIColor.lightGray.cgColor
        topView.layer.borderWidth = 1
    }

}
