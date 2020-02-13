//
//  UIImage+Extension.swift
//  DecorYou
//
//  Created by Hamburger on 2020/1/22.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

enum ImageAsset: String {

    // Profile tab - Tab
    
    // swiftlint:disable identifier_name
    case Icons_36px_NewsFeed_Normal
    case Icons_36px_NewsFeed_Selected
    case Icons_36px_Tool_Normal
    case Icons_36px_Tool_Selected
    case Icons_36px_Chat_Normal
    case Icons_36px_Chat_Selected
    case Icons_36px_Account_Normal
    case Icons_36px_Account_Selected
    
    case Icons_36px_Home_Normal
    case Icons_36px_Home_Selected
    case Icons_36px_Profile_Normal
    case Icons_36px_Profile_Selected

    // Profile tab - Order
    case Icons_24px_AwaitingPayment
    case Icons_24px_AwaitingShipment
    case Icons_24px_AwaitingReview
    case Icons_24px_Exchange

    // Profile tab - Service
    case Icons_24px_Starred
    case Icons_24px_Notification
    case Icons_24px_Address
    case Icons_24px_CustomerService
    case Icons_24px_SystemFeedback
    case Icons_24px_RegisterCellphone
    case Icons_24px_Settings

    //Product page
    case Icons_24px_CollectionView
    case Icons_24px_ListView

    //Back button
    case Icons_24px_Back02
    
    //Drop down
    case Icons_24px_DropDown
    
    //Filter Icon    
    case Icons_24px_Favorite
    case Icons_24px_reply
    case Icons_24px_More
    case Icons_24px_Floor
    case Icons_24px_Refresh
    case Icons_48px_Back01
    case Icons_24px_Back03
    case Icons_24px_Location
    case Icons_24px_Album
    case Icons_24px_Photos
    case Icons_24px_HomeSize
    case Icons_24px_Craftsmen
    case Icons_24px_DecorateStyle
    case Icons_24px_NewPost
    case Icons_24px_Camera
    case Icons_24px_Filter
    case Icons_24px_Layout
}

// swiftlint:enable identifier_name

extension UIImage {

    static func asset(_ asset: ImageAsset) -> UIImage? {

        return UIImage(named: asset.rawValue)
    }
}
