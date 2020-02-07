//
//  ArticleManager.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/7.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import FirebaseCore
import FirebaseFirestore

struct Article {
    let title: String
    let content: String
    let loveCount: Int
    let reply: [Article]
    let comment: [Comment]
    let authorName: String
    let authorUID: String
    let createTime: Date
    let postID: String
}

struct Comment {
    let authorName: String
    let authorLogo: String
    let comment: String
}

class ArticleManager {
    
    static let shared = ArticleManager()
    
    private init() {}
    
    lazy var db = Firestore.firestore()
    
    //創建用戶
    func addPost(title: String,
                 content: String,
                 loveCount: Int,
                 reply: [Article],
                 comment: [Comment],
                 authorName: String,
                 authorUID: String,
                 createTime: Date) {
        let newPost = db.collection("article").document()
        db.collection("article").document("\(newPost.documentID)").setData([
            "title": title,
            "content": content,
            "loveCount": loveCount,
            "reply": reply,
            "comment": comment,
            "authorName": authorName,
            "authorUID": authorUID,
            "createTime": createTime,
            "postID": newPost.documentID
        ]){ (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    //讀取用戶
//    func fetchPost() {
//        db.collection("users").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                guard let querySnapShot = querySnapshot else { return }
//                var userArray = [User]()
//                for document in querySnapShot.documents {
//                    let data = document.data()
//                    guard let name = data["name"] as? String else { return }
//                    guard let uid = data["uid"] as? String else { return }
//                    guard let email = data["email"] as? String else { return }
//                    let img = data["img"] as? String
//                    guard let lovePost = data["lovePost"] as? [String] else { return }
//                    guard let selfPost = data["selfPost"] as? [String] else { return }
//                    guard let character = data["character"] as? String else { return }
//                    let user = User(email: email, name: name, uid: uid, img: img, lovePost: lovePost, selfPost: selfPost, character: character)
//                    userArray.append(user)
//                    print(user)
//                }
//                //self.userDelegate?.passUserData(manager: self, userData: userArray)
//            }
//        }
//    }
    /*
    func fetchSpecificPost(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").whereField("uid", isEqualTo: uid).getDocuments() { [weak self] (querySnapshot, err) in
            guard let strongSelf = self else { return }
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let querySnapShot = querySnapshot else { return }
                for document in querySnapShot.documents {
                    let data = document.data()
                    guard let name = data["name"] as? String else { return }
                    guard let uid = data["uid"] as? String else { return }
                    guard let email = data["email"] as? String else { return }
                    let img = data["img"] as? String
                    guard let lovePost = data["lovePost"] as? [String] else { return }
                    guard let selfPost = data["selfPost"] as? [String] else { return }
                    guard let character = data["character"] as? String else { return }
                    strongSelf.userInfo = User(email: email, name: name, uid: uid, img: img, lovePost: lovePost, selfPost: selfPost, character: character)
                    guard let user = strongSelf.userInfo else { return }
                    completion(.success(user))
                }
            }
        }
    }
    
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
