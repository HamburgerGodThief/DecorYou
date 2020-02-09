//
//  UserManager.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/6.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import FirebaseCore
import FirebaseFirestore

struct User {
    let email: String
    let name: String
    let uid: String
    let img: String?
    let lovePost: [String]
    let selfPost: [String]
    let character: String
}

struct Craftsmen {
    var email: String
    let name: String
    let uid: String
    let img: String?
    let lovePost: [String]
    let selfPost: [String]
    let character: String
    var select: Bool
}

class UserManager {
    
    static let shared = UserManager()
    var userInfo: User?
    
    private init() {}
    
    lazy var db = Firestore.firestore()
    
    //創建用戶
    func addUserData(name: String, uid: String, email: String, lovePost: [String], selfPost: [String], character: String) {
        db.collection("users").document(uid).setData ([
            "email": email,
            "uid": uid,
            "name": name,
            "img": "",
            "lovePost": lovePost,
            "selfPost": selfPost,
            "character": character
        ]){ (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    //讀取用戶
    func fetchAllUser() {
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let querySnapShot = querySnapshot else { return }
                var userArray = [User]()
                for document in querySnapShot.documents {
                    let data = document.data()
                    guard let name = data["name"] as? String else { return }
                    guard let uid = data["uid"] as? String else { return }
                    guard let email = data["email"] as? String else { return }
                    let img = data["img"] as? String
                    guard let lovePost = data["lovePost"] as? [String] else { return }
                    guard let selfPost = data["selfPost"] as? [String] else { return }
                    guard let character = data["character"] as? String else { return }
                    let user = User(email: email, name: name, uid: uid, img: img, lovePost: lovePost, selfPost: selfPost, character: character)
                    userArray.append(user)
                    print(user)
                }
                //self.userDelegate?.passUserData(manager: self, userData: userArray)
            }
        }
    }
    
    func fetchCurrentUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
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
    
    func fetchAllCraftsmen(completion: @escaping (Result<[User], Error>) -> Void) {
        db.collection("users").whereField("character", isEqualTo: "Craftsmen").getDocuments() {(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let querySnapShot = querySnapshot else { return }
                var allCraftsmen = [User]()
                for document in querySnapShot.documents {
                    let data = document.data()
                    guard let name = data["name"] as? String else { return }
                    guard let uid = data["uid"] as? String else { return }
                    guard let email = data["email"] as? String else { return }
                    let img = data["img"] as? String
                    guard let lovePost = data["lovePost"] as? [String] else { return }
                    guard let selfPost = data["selfPost"] as? [String] else { return }
                    guard let character = data["character"] as? String else { return }
                    allCraftsmen.append(User(email: email, name: name, uid: uid, img: img, lovePost: lovePost, selfPost: selfPost, character: character))
                }
                completion(.success(allCraftsmen))
            }
        }
    }
    
    func updateUser(uid: String, name: String, img: String, lovePost: [String], selfPost: [String]) {
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
}
