//
//  SwiftMessageWrapper.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/26.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import SwiftMessages

class SwiftMes {
    
    static let shared = SwiftMes()
    private init() { }
    
    func showSuccessMessage(title: String, body: String, seconds: Double) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: title, body: body)
        view.button?.isHidden = true
        view.configureTheme(.success)
        view.configureDropShadow()
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        config.duration = .seconds(seconds: seconds)
        config.interactiveHide = false
        config.preferredStatusBarStyle = .lightContent
        SwiftMessages.show(config: config, view: view)
    }
    
    func showFailMessage(title: String, body: String, seconds: Double) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: title, body: body)
        view.button?.isHidden = true
        view.configureTheme(.error)
        view.configureDropShadow()
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        config.duration = .seconds(seconds: seconds)
        config.interactiveHide = false
        config.preferredStatusBarStyle = .lightContent
        SwiftMessages.show(config: config, view: view)
    }
}
