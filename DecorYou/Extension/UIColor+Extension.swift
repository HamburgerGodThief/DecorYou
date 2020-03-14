//
//  UIColor+Extension.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/7.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

enum STColor: String {

    case mainColor
    case highlightColor
    case shadowLightGray
    case darkMainColor
    case favoriteColor
    case readPostColor
    case advertise
}

extension UIColor {

    static func assetColor(_ color: STColor) -> UIColor? {

        return UIColor(named: color.rawValue)
    }
}
