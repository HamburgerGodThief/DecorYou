//
//  CraftsmenFilterCondition.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/23.
//  Copyright © 2020 Hamburger. All rights reserved.
//

protocol CraftsmenConditionProtocol {
    
    func filter(data: [User]) -> [User]
    
}

struct ServiceCategoryCondition: CraftsmenConditionProtocol {
        
    var conditionValue: String
    
    func filter(data: [User]) -> [User] {
        let filterData = data.filter({ $0.serviceCategory == conditionValue })
        return filterData
    }
}

struct ServiceLocationCondition: CraftsmenConditionProtocol {
        
    var conditionValue: String
    
    func filter(data: [User]) -> [User] {
        let filterData = data.filter({ craftsmen in
            craftsmen.serviceLocation.contains(where: { $0 == conditionValue })
        })
        return filterData
    }
}
