//
//  CALayer+Extension.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/4.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class RoundCornerAndShadow: UIView {
    
    func layoutTableView(_ tableView: UITableView, radius: CGFloat, color: UIColor, offset: CGSize, opacity: Float, cornerRadius: CGFloat) {

        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        layer.masksToBounds = false
        
        tableView.layer.cornerRadius = cornerRadius
        tableView.clipsToBounds = true
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}