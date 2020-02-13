//
//  UserManager.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/6.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Codable {
    let email: String
    let name: String
    let uid: String
    let img: String?
    let lovePost: [DocumentReference]
    let selfPost: [DocumentReference]
    let character: String
}

struct Craftsmen: Codable {
    
    let email: String
    let name: String
    let uid: String
    var img: String?
    let lovePost: [DocumentReference]
    let selfPost: [DocumentReference]
    let character: String
    let serviceLocation: [String]
    let serviceCategory: String
    var select: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case email, name, uid, character, serviceLocation, serviceCategory, lovePost, selfPost
    }
}

class UserManager {
    
    static let shared = UserManager()
    var userInfo: User?
    var craftsmenInfo: Craftsmen?
    
    private init() {}
    
    lazy var db = Firestore.firestore()
    
    //創建一般用戶
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
    
    //創建匠人
    func addCraftsmanData(uid: String, craftman: Craftsmen) {
        do {
            try db.collection("craftsmen").document(uid).setData(from: craftman)
        } catch {
            print("Error writing city to Firestore: \(error)")
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
                    guard let lovePost = data["lovePost"] as? [DocumentReference] else { return }
                    guard let selfPost = data["selfPost"] as? [DocumentReference] else { return }
                    guard let character = data["character"] as? String else { return }
                    let user = User(email: email, name: name, uid: uid, img: img, lovePost: lovePost, selfPost: selfPost, character: character)
                    userArray.append(user)
                    print(user)
                }
            }
        }
    }
    
    func fetchCurrentUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").whereField("uid", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let querySnapShot = querySnapshot else { return }
                for document in querySnapShot.documents {
                    do {
                        if let user = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                            completion(.success(user))
                        }
                    } catch {
                        print(error)
                        return
                    }
                }
            }
        }
    }
    
    func fetchCurrentCraftsmen(uid: String, completion: @escaping (Result<Craftsmen, Error>) -> Void) {
        db.collection("craftsmen").whereField("uid", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let querySnapShot = querySnapshot else { return }
                for document in querySnapShot.documents {
                    do {
                        if let craftsmen = try document.data(as: Craftsmen.self, decoder: Firestore.Decoder()) {
                            completion(.success(craftsmen))
                        }
                    } catch {
                        print(error)
                        return
                    }
                }
            }
        }
    }
    
    func fetchSpecificUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").whereField("uid", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
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
                    guard let lovePost = data["lovePost"] as? [DocumentReference] else { return }
                    guard let selfPost = data["selfPost"] as? [DocumentReference] else { return }
                    guard let character = data["character"] as? String else { return }
                    let user = User(email: email, name: name, uid: uid, img: img, lovePost: lovePost, selfPost: selfPost, character: character)
                    completion(.success(user))
                }
            }
        }
    }
    
    func fetchAllCraftsmen(completion: @escaping (Result<[Craftsmen], Error>) -> Void) {
        db.collection("craftsmen").getDocuments() {(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let querySnapShot = querySnapshot else { return }
                var allCraftsmen: [Craftsmen] = []
                querySnapShot.documents.forEach { document in
                    do {
                        if let craftsmen = try document.data(as: Craftsmen.self, decoder: Firestore.Decoder()) {
                            allCraftsmen.append(craftsmen)
                        }
                    } catch{
                        completion(.failure(error))
                        return
                    }
                }
                completion(.success(allCraftsmen))
            }
        }
    }
    
    func updateUser(uid: String, name: String, img: String, lovePost: [DocumentReference], selfPost: [DocumentReference]) {
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
    
    func updataUserSelfPost(uid: String, selfPost: [DocumentReference]) {
        db.collection("users").document(uid).updateData([
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
