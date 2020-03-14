//
//  ArticleFilterModel.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/22.
//  Copyright © 2020 Hamburger. All rights reserved.
//
protocol ConditionProtocol {
    
    var conditionType: String { get set }
    
    func filter(data: [Article]) -> [Article]
    
}

struct StyleCondition: ConditionProtocol {
    
    var conditionType: String = "StyleCondition"
    
    var conditionValue: String
    
    func filter(data: [Article]) -> [Article] {
        let filterData = data.filter({ $0.decorateStyle == conditionValue })
        return filterData
    }
}

struct LocationCondition: ConditionProtocol {
    
    var conditionType: String = "LocationCondition"
    
    var conditionValue: String
    
    func filter(data: [Article]) -> [Article] {
        let filterData = data.filter({ $0.location == conditionValue })
        return filterData
    }
}

struct SizeMinCondition: ConditionProtocol {
    
    var conditionType: String = "SizeMinCondition"

    var conditionValue: Int
    
    func filter(data: [Article]) -> [Article] {
        let filterData = data.filter({ $0.size ?? 0 > conditionValue })
        return filterData
    }
}

struct SizeMaxCondition: ConditionProtocol {
    
    var conditionType: String = "SizeMaxCondition"
    
    var conditionValue: Int
    
    func filter(data: [Article]) -> [Article] {
        let filterData = data.filter({ $0.size ?? 0 < conditionValue })
        return filterData
    }
}

struct ReplyMinCondition: ConditionProtocol {
    
    var conditionType: String = "ReplyMinCondition"
    
    var conditionValue: Int
    
    func filter(data: [Article]) -> [Article] {
        let filterData = data.filter({ $0.size ?? 0 > conditionValue })
        return filterData
    }
}

struct ReplyMaxCondition: ConditionProtocol {
    
    var conditionType: String = "ReplyMaxCondition"

    var conditionValue: Int
    
    func filter(data: [Article]) -> [Article] {
        let filterData = data.filter({ $0.size ?? 0 < conditionValue })
        return filterData
    }
}

struct LoveMinCondition: ConditionProtocol {
    
    var conditionType: String = "LoveMinCondition"
    
    var conditionValue: Int
    
    func filter(data: [Article]) -> [Article] {
        let filterData = data.filter({ $0.loveCount > conditionValue })
        return filterData
    }
    
}

struct LoveMaxCondition: ConditionProtocol {
    
    var conditionType: String = "LoveMaxCondition"
    var conditionValue: Int
    
    func filter(data: [Article]) -> [Article] {
        let filterData = data.filter({ $0.loveCount < conditionValue })
        return filterData
    }
    
}
