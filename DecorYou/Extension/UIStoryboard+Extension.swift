//
//  UIStoryboard+Extension.swift
//  DecorYou
//
//  Created by Hamburger on 2020/1/22.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

private struct StoryboardCategory {

    static let main = "Main"
    
    static let auth = "Auth"

    static let article = "Article"

    static let craftsmen = "Craftsmen"

    static let chat = "Chat"
    
    static let profile = "Profile"
    
}

extension UIStoryboard {

    static var main: UIStoryboard { return stStoryboard(name: StoryboardCategory.main) }

    static var auth: UIStoryboard { return stStoryboard(name: StoryboardCategory.auth) }

    static var article: UIStoryboard { return stStoryboard(name: StoryboardCategory.article) }

    static var craftsmen: UIStoryboard { return stStoryboard(name: StoryboardCategory.craftsmen) }
    
    static var chat: UIStoryboard { return stStoryboard(name: StoryboardCategory.chat) }

    static var profile: UIStoryboard { return stStoryboard(name: StoryboardCategory.profile) }

    private static func stStoryboard(name: String) -> UIStoryboard {

        return UIStoryboard(name: name, bundle: nil)
    }
}
