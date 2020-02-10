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
    
//    func fetchSpecificPost(postID: String, completion: @escaping (Result<Article, Error>) -> Void) {
//        db.collection("article").whereField("postID", isEqualTo: postID).getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                guard let querySnapShot = querySnapshot else { return }
//                for document in querySnapShot.documents {
//                    let data = document.data()
//                    guard let title = data["title"] as? String else { return }
//                    guard let authorName = data["authorName"] as? String else { return }
//                    guard let authorUID = data["authorUID"] as? String else { return }
//                    guard let content = data["content"] as? String else { return }
//                    guard let createTime = data["createTime"] as? Date else { return }
//                    guard let decorateStyle = data["decorateStyle"] as? [String] else { return }
//                    let location = data["location"] as? String?
//                    guard let loveCount = data["loveCount"] as? Int else { return }
//                    guard let postID = data["postID"] as? String else { return }
//                    guard let comment = data["comment"] as? [DocumentReference] else { return }
//                    guard let reply = data["reply"] as? [DocumentReference] else { return }
//                    let size = data["size"] as? String?
//                    guard let collaborator = data["collaborator"] as? [DocumentReference] else { return}
//                    let article = Article(title: title,
//                                          authorName: authorName,
//                                          authorUID: authorUID,
//                                          content: content,
//                                          createTime: createTime,
//                                          decorateStyle: decorateStyle,
//                                          location: location ?? nil,
//                                          loveCount: loveCount,
//                                          postID: postID,
//                                          size: size ?? nil,
//                                          collaborator: collaborator,
//                                          reply: reply,
//                                          comment: comment)
//                    completion(.success(article))
//                }
//            }
//        }
//    }
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
