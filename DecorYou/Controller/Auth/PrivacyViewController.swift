//
//  PrivacyViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/3/5.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit
import WebKit

class PrivacyViewController: UIViewController {
 
    @IBOutlet weak var wkWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://github.com/HamburgerGodThief/Privacy-Police")
        let urlRequest = URLRequest(url: url!)
        wkWebView.load(urlRequest)
    }
    

}
