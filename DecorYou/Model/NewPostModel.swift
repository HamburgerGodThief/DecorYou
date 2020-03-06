//
//  NewPostModel.swift
//  DecorYou
//
//  Created by Hamburger on 2020/3/6.
//  Copyright © 2020 Hamburger. All rights reserved.
//
import UIKit

protocol NewPostData {
    
    var cellType: CellType { get }
}

struct NewPostTextView: NewPostData {
    
    let cellType: CellType = .textView
    var text: String
}

struct NewPostImage: NewPostData {
    
    let cellType: CellType = .image
    var image: UIImage
}

enum CellType {
    case textView
    case image
}
