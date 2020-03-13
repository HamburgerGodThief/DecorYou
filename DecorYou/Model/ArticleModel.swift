//
//  ArticleModel.swift
//  DecorYou
//
//  Created by Hamburger on 2020/3/9.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Article: Codable, Equatable {
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        if lhs.title == rhs.title,
            lhs.type == rhs.type,
            lhs.author == rhs.author,
            lhs.content == rhs.content,
            lhs.decorateStyle == rhs.decorateStyle,
            lhs.location == rhs.location,
            lhs.loveCount == rhs.loveCount,
            lhs.postID == rhs.postID
             {
            return true
        } else {
            return false
        }
    }
    
    let title: String
    let type: String
    var content: [String]
    let createTime: Date
    let decorateStyle: String?
    let location: String?
    var loveCount: Int
    var replyCount: Int
    let postID: String
    let size: Int?
    let collaborator: [DocumentReference]
    let author: DocumentReference
    var authorObject: User?
    var intervalString: String {
        let interval = Date().timeIntervalSince(createTime)
        let days = Double(60 * 60 * 24)
        let hours = Double(60 * 60)
        let minutes = Double(60)
        
        if interval / days >= 1 {
            return "\(Int(interval / days))天前"
        } else {
            if interval / hours >= 1 {
                return "\(Int(interval / hours))小時前"
            } else {
                return "\(Int(interval / minutes))分前"
            }
        }
    }
    var createTimeString: String {
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd HH:mm"
        return format.string(from: createTime)
    }
    
    enum CodingKeys: String, CodingKey {
        case author, title, type, postID, content, createTime, collaborator, size, loveCount, replyCount, location, decorateStyle
    }
}

struct Reply: Codable {
    let author: DocumentReference
    var authorObject: User?
    var content: [String]
    let createTime: Date
    let replyID: String
    var comments: [Comment] = []
    var intervalString: String {
        let interval = Date().timeIntervalSince(createTime)
        let days = Double(60 * 60 * 24)
        let hours = Double(60 * 60)
        let minutes = Double(60)
        
        if interval / days >= 1 {
            return "\(Int(interval / days))天前"
        } else {
            if interval / hours >= 1 {
                return "\(Int(interval / hours))小時前"
            } else {
                return "\(Int(interval / minutes))分前"
            }
        }
    }
    var createTimeString: String {
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd HH:mm"
        return format.string(from: createTime)
    }
    
    enum CodingKeys: String, CodingKey {
        case author, content, createTime, replyID
    }
}

struct Comment: Codable {
    
    let author: DocumentReference
    var authorObject: User?
    var content: String
    let createTime: Date
    let commentID: String
    var intervalString: String {
        let interval = Date().timeIntervalSince(createTime)
        let days = Double(60 * 60 * 24)
        let hours = Double(60 * 60)
        let minutes = Double(60)
        
        if interval / days >= 1 {
            return "\(Int(interval / days))天前"
        } else {
            if interval / hours >= 1 {
                return "\(Int(interval / hours))小時前"
            } else {
                return "\(Int(interval / minutes))分前"
            }
        }
    }
    var createTimeString: String {
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd HH:mm"
        return format.string(from: createTime)
    }
    
    enum CodingKeys: String, CodingKey {
        case author, content, createTime, commentID
    }
}
