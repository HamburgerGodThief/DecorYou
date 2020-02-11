//
//  ArticleManager.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/7.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Article: Codable {
    let title: String
    let authorName: String
    let authorUID: String
    let content: String
    let createTime: Date
    var createTimeString: String {
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd HH:mm"
        return format.string(from: createTime)
    }
    let decorateStyle: [String]
    let location: String?
    let loveCount: Int
    let postID: String
    let size: String?
    let collaborator: [DocumentReference]
    let author: DocumentReference
}

struct Reply: Codable {
    let author: DocumentReference
    var authorObject: User?
    let content: String
    let createTime: Date
    var createTimeString: String {
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd HH:mm"
        return format.string(from: createTime)
    }
    let replyID: String
    var comments: [Comment] = []
    
    enum CodingKeys: String, CodingKey {
        case author, content, createTime, replyID
    }
}

struct Comment: Codable {
    
    let author: DocumentReference
    var authorObject: User?
    let content: String
    let createTime: Date
    var createTimeString: String {
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd HH:mm"
        return format.string(from: createTime)
    }
    let commentID: String
    
    enum CodingKeys: String, CodingKey {
        case author, content, createTime, commentID
    }
}

class ArticleManager {
    
    static let shared = ArticleManager()
    
    private init() {}
    
    lazy var db = Firestore.firestore()
    
    //創建貼文
    func addPost(newPost: DocumentReference,
                 title: String,
                 content: String,
                 loveCount: Int,
                 replys: [DocumentReference],
                 comments: [DocumentReference],
                 authorName: String,
                 authorUID: String,
                 createTime: Date,
                 decorateStyle: [String],
                 location: String?,
                 size: String?,
                 collaboratorRef: [DocumentReference],
                 author: DocumentReference) {
//        let newPost = db.collection("article").document()
        db.collection("article").document("\(newPost.documentID)").setData([
            "title": title,
            "content": content,
            "loveCount": loveCount,
            "replys": replys,
            "comments": comments,
            "authorName": authorName,
            "authorUID": authorUID,
            "createTime": createTime,
            "decorateStyle": decorateStyle,
            "location": location ?? "",
            "size": size ?? "",
            "collaborator": collaboratorRef,
            "postID": newPost.documentID,
            "author": author
        ]){ (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    //讀取貼文
    func fetchAllPost(completion: @escaping (Result<[Article], Error>) -> Void) {
        db.collection("article").order(by: "createTime", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let querySnapShot = querySnapshot else { return }
                var articles = [Article]()
                querySnapShot.documents.forEach { document in
                    do {
                        if let article = try document.data(as: Article.self, decoder: Firestore.Decoder()) {
                            articles.append(article)
                        }
                    } catch{
                        completion(.failure(error))
                        return
                    }
                }
                completion(.success(articles))
            }
        }
    }
    //回覆文章
    func replyPost(postID: String, newReplyID: String, reply: Reply) {
        
        do { try db.collection("article").document("\(postID)").collection("replys").document(newReplyID).setData(from: reply)
        } catch {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    //樓主文章的留言
    func commentMainPost(postID: String, newCommentID: String, comment: Comment) {
        do { try db.collection("article").document("\(postID)").collection("comments").document(newCommentID).setData(from: comment)
        } catch {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    //回文的留言
    func commentReplyPost(postID: String, replyID: String, newCommentID: String, comment: Comment) {
        do { try db.collection("article").document("\(postID)").collection("replys").document(replyID).collection("comments").document(newCommentID).setData(from: comment)
        } catch {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    
    /*
    func updatePost(uid: String, name: String, img: String, lovePost: [String], selfPost: [String]) {
        db.collection("users").document(uid).updateData([
            "name": name,
            "img": img,
            "lovePost": lovePost,
            "selfPost": selfPost
        ]) { err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
 */
}
