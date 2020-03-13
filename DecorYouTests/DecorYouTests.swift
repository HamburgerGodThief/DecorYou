//
//  DecorYouTests.swift
//  DecorYouTests
//
//  Created by Hamburger on 2020/3/9.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import XCTest
@testable import DecorYou
import Firebase

class SizeMinConditionTests: XCTestCase {
    
    var sut: SizeMinCondition!
    
    override func setUp() {
        sut = SizeMinCondition(conditionValue: 12)
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func tests_filter() {
        
        let date = Date()
        
        let firstArticle = Article(title: "",
                                   type: "",
                                   content: [],
                                   createTime: date,
                                   decorateStyle: nil,
                                   location: nil,
                                   loveCount: 1,
                                   replyCount: 1,
                                   postID: "",
                                   size: 10,
                                   collaborator: [],
                                   author: UserManager.shared.db.collection("users").document(),
                                   authorObject: nil)
        
        let secondArticle = Article(title: "",
                                    type: "",
                                    content: [],
                                    createTime: date,
                                    decorateStyle: nil,
                                    location: nil,
                                    loveCount: 1,
                                    replyCount: 1,
                                    postID: "",
                                    size: 15,
                                    collaborator: [],
                                    author: UserManager.shared.db.collection("users").document(),
                                    authorObject: nil)
        
        let thirdArticle = Article(title: "",
                                   type: "",
                                   content: [],
                                   createTime: date,
                                   decorateStyle: nil,
                                   location: nil,
                                   loveCount: 1,
                                   replyCount: 1,
                                   postID: "",
                                   size: 30,
                                   collaborator: [],
                                   author: UserManager.shared.db.collection("users").document(),
                                   authorObject: nil)
        
        let fourAricle = Article(title: "",
                                 type: "",
                                 content: [],
                                 createTime: date,
                                 decorateStyle: nil,
                                 location: nil,
                                 loveCount: 1,
                                 replyCount: 3,
                                 postID: "",
                                 size: 30,
                                 collaborator: [],
                                 author: UserManager.shared.db.collection("users").document(),
                                 authorObject: nil)
        
        let data = [firstArticle, secondArticle, thirdArticle, fourAricle]
        
        let testResult = sut.filter(data: data)
        
        let expectedValue = [secondArticle, thirdArticle, fourAricle]
        
        let expectedValue2 = [secondArticle, thirdArticle, thirdArticle]
        
        XCTAssertEqual(testResult, expectedValue2)
    }
    
    
}
