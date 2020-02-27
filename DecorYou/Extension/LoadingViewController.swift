//
//  LoadingViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/25.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit
import Lottie

class LoadingViewController: UIViewController {

    @IBOutlet weak var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.animation = Animation.named("loadingAnimate")
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.2
        animationView.play()
        // Do any additional setup after loading the view.
    }

}
