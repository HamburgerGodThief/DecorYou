//
//  FilterModel.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/22.
//  Copyright © 2020 Hamburger. All rights reserved.
//
protocol ConditionDelegate {
    
    var conditionType: String { get set }
    
    func filter(data: [Article]) -> [Article]
    
}

struct StyleCondition: ConditionDelegate {
    
    var conditionType: String = "StyleCondition"
    
    var conditionValue: String
    
    func filter(data: [Article]) -> [Article] {
        let filterData = data.filter({ article in
            article.decorateStyle.contains(where: { $0 == conditionValue})
        })
        return filterData
    }
}

struct LocationCondition: ConditionDelegate {
    
    var conditionType: String = "LocationCondition"
    
    var conditionValue: String
    
    func filter(data: [Article]) -> [Article] {
        let filterData = data.filter({ $0.location == conditionValue })
        return filterData
    }
}

struct SizeMinCondition: ConditionDelegate {
    var conditionType: String = "SizeMinCondition"

    var conditionValue: Int
    
    func filter(data: [Article]) -> [Article] {
        let filterData = data.filter({ $0.size ?? 0 > conditionValue })
        return filterData
    }
}

struct SizeMaxCondition: ConditionDelegate {
    var conditionType: String = "SizeMaxCondition"
    

    var conditionValue: Int
    
    func filter(data: [Article]) -> [Article] {
        let filterData = data.filter({ $0.size ?? 0 < conditionValue })
        return filterData
    }
}

struct ReplyMinCondition: ConditionDelegate {
    var conditionType: String = "ReplyMinCondition"
    

    var conditionValue: Int
    
    func filter(data: [Article]) -> [Article] {
        let filterData = data.filter({ $0.size ?? 0 > conditionValue })
        return filterData
    }
}

struct ReplyMaxCondition: ConditionDelegate {
    var conditionType: String = "ReplyMaxCondition"
    

    var conditionValue: Int
    
    func filter(data: [Article]) -> [Article] {
        let filterData = data.filter({ $0.size ?? 0 < conditionValue })
        return filterData
    }
}

struct LoveMinCondition: ConditionDelegate {
    var conditionType: String = "LoveMinCondition"
    

    var conditionValue: Int
    
    func filter(data: [Article]) -> [Article] {
        let filterData = data.filter({ $0.loveCount > conditionValue })
        return filterData
    }
    
}

struct LoveMaxCondition: ConditionDelegate {
    var conditionType: String = "LoveMaxCondition"
    

    var conditionValue: Int
    
    func filter(data: [Article]) -> [Article] {
        let filterData = data.filter({ $0.loveCount < conditionValue })
        return filterData
    }
    
}
