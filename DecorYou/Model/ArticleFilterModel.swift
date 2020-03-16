//
//  ArticleFilterModel.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/22.
//  Copyright © 2020 Hamburger. All rights reserved.
//
import UIKit

protocol ConditionProtocol: UITextFieldDelegate {
    
    var conditionType: String { get set }
    
    func filter(data: [Article]) -> [Article]
    
}

class StyleCondition: NSObject, ConditionProtocol {
    
    var conditionType: String = "StyleCondition"
    
    var conditionValue: String
    
    init(conditionValue: String) {
        self.conditionValue = conditionValue
    }
    
    func filter(data: [Article]) -> [Article] {
        if conditionValue == "" {
            return data
        }
        let filterData = data.filter({ $0.decorateStyle == conditionValue })
        return filterData
    }
}

class LocationCondition: NSObject, ConditionProtocol {
    
    var conditionType: String = "LocationCondition"
    
    var conditionValue: String
    
    init(conditionValue: String) {
        self.conditionValue = conditionValue
    }
    
    func filter(data: [Article]) -> [Article] {
        if conditionValue == "" {
            return data
        }
        let filterData = data.filter({ $0.location == conditionValue })
        return filterData
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.conditionValue = textField.text!
    }
}

class SizeMinCondition: NSObject, ConditionProtocol {
    
    var conditionType: String = "SizeMinCondition"

    var conditionValue: Int
    
    init(conditionValue: Int) {
        self.conditionValue = conditionValue
    }
    
    func filter(data: [Article]) -> [Article] {
        if conditionValue == 0 {
            return data
        }
        let filterData = data.filter({ $0.size ?? 0 > conditionValue })
        return filterData
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.conditionValue = Int(textField.text!) ?? 0
    }
}

class SizeMaxCondition: NSObject, ConditionProtocol {
    
    var conditionType: String = "SizeMaxCondition"
    
    var conditionValue: Int
    
    init(conditionValue: Int) {
        self.conditionValue = conditionValue
    }
    
    func filter(data: [Article]) -> [Article] {
        if conditionValue == 0 {
            return data
        }
        let filterData = data.filter({ $0.size ?? 0 < conditionValue })
        return filterData
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.conditionValue = Int(textField.text!) ?? 0
    }
}

class ReplyMinCondition: NSObject, ConditionProtocol {
    
    var conditionType: String = "ReplyMinCondition"
    
    var conditionValue: Int
    
    init(conditionValue: Int) {
        self.conditionValue = conditionValue
    }
    
    func filter(data: [Article]) -> [Article] {
        if conditionValue == 0 {
            return data
        }
        let filterData = data.filter({ $0.replyCount > conditionValue })
        return filterData
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.conditionValue = Int(textField.text!) ?? 0
    }
}

class ReplyMaxCondition: NSObject, ConditionProtocol {
    
    var conditionType: String = "ReplyMaxCondition"

    var conditionValue: Int
    
    init(conditionValue: Int) {
        self.conditionValue = conditionValue
    }
    
    func filter(data: [Article]) -> [Article] {
        if conditionValue == 0 {
            return data
        }
        let filterData = data.filter({ $0.replyCount < conditionValue })
        return filterData
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.conditionValue = Int(textField.text!) ?? 0
    }
}

class LoveMinCondition: NSObject, ConditionProtocol {
    
    var conditionType: String = "LoveMinCondition"
    
    var conditionValue: Int
    
    init(conditionValue: Int) {
        self.conditionValue = conditionValue
    }
    
    func filter(data: [Article]) -> [Article] {
        if conditionValue == 0 {
            return data
        }
        let filterData = data.filter({ $0.loveCount > conditionValue })
        return filterData
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.conditionValue = Int(textField.text!) ?? 0
    }
    
}

class LoveMaxCondition: NSObject, ConditionProtocol {
    
    var conditionType: String = "LoveMaxCondition"
    
    var conditionValue: Int
    
    init(conditionValue: Int) {
        self.conditionValue = conditionValue
    }
    
    func filter(data: [Article]) -> [Article] {
        if conditionValue == 0 {
            return data
        }
        let filterData = data.filter({ $0.loveCount < conditionValue })
        return filterData
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.conditionValue = Int(textField.text!) ?? 0
    }
    
}
