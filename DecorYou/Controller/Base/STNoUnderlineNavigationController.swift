//
//  STNoUnderlineNavigationController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/1/26.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class STNoUnderlineNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = false

        navigationBar.setBackgroundImage(UIImage(), for: .default)

        navigationBar.shadowImage = UIImage()
    }

}

