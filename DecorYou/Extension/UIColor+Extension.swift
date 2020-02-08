//
//  UIColor+Extension.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/7.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

enum STColor: String {

    // swiftlint:disable identifier_name
    case mainColor
    case highlightColor
}

extension UIColor {

    static func assetColor(_ color: STColor) -> UIColor? {

        return UIColor(named: color.rawValue)
    }
}
