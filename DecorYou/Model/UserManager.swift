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
    
    let uid: String
    let email: String
    let name: String
    var img: String?
    var backgroundImg: String?
    var lovePost: [DocumentReference]
    var selfPost: [DocumentReference]
    var blockUser: [String]
    let character: String
    let serviceLocation: [String]
    var serviceCategory: String?
    var select: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case uid, email, name, img, backgroundImg, lovePost, selfPost, blockUser, character, serviceLocation, serviceCategory
    }
}

struct PhotoSet {
    let name: String
    let images: [String]
}

struct Profolio: Codable {
    
    var coverImg: String
    var livingRoom: [String]
    var dinningRoom: [String]
    var mainRoom: [String]
    var firstRoom: [String]
    var kitchen: [String]
    var bathRoom: [String]
    var totalArea: [String]
    let createTime: Date
    var createTimeString: String {
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd HH:mm"
        return format.string(from: createTime)
    }
    
    enum CodingKeys: String, CodingKey {
        case coverImg, livingRoom, dinningRoom, mainRoom, firstRoom, kitchen, bathRoom, totalArea, createTime
    }
    
    var dataSet: [PhotoSet] {
        
        return [
            PhotoSet(name: "客廳", images: livingRoom),
            PhotoSet(name: "餐廳", images: dinningRoom),
            PhotoSet(name: "廚房", images: kitchen),
            PhotoSet(name: "主臥室", images: mainRoom),
            PhotoSet(name: "其他臥室", images: firstRoom),
            PhotoSet(name: "浴室", images: bathRoom)
        ]
    }
}

class UserManager {
    
    static let shared = UserManager()
    var user: User?
    
    private init() {}
    
    lazy var db = Firestore.firestore()
    
    //創建用戶
    func addUserData(uid: String, user: User) {
        do {
            try db.collection("users").document(uid).setData(from: user)
        } catch {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    //創建Profolio
    func addProfolio(profolio: Profolio) {
        guard let uid = UserDefaults.standard.string(forKey: "UserToken") else { return }
        do {
            try db.collection("users").document(uid).collection("Profolio").document().setData(from: profolio)
        } catch {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    //讀取所有User
    func fetchAllUser(completion: @escaping (Result<[User], Error>) -> Void) {
        db.collection("users").getDocuments() {(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let querySnapShot = querySnapshot else { return }
                var allUser: [User] = []
                querySnapShot.documents.forEach { document in
                    do {
                        if let user = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                            allUser.append(user)
                        }
                    } catch{
                        completion(.failure(error))
                        return
                    }
                }
                completion(.success(allUser))
            }
        }
    }
    
    //讀取所有匠人
    func fetchAllCraftsmen(completion: @escaping (Result<[User], Error>) -> Void) {
        db.collection("users").whereField("character", isEqualTo: "craftsmen").getDocuments() {(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let querySnapShot = querySnapshot else { return }
                var allCraftsmen: [User] = []
                querySnapShot.documents.forEach { document in
                    do {
                        if let craftsmen = try document.data(as: User.self, decoder: Firestore.Decoder()) {
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
    
    func fetchCurrentUser(uid: String) {
        db.collection("users").document(uid).getDocument() { (document, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let document = document else { return }
                do {
                    if let user = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                        UserManager.shared.user = user
                        NotificationCenter.default.post(name: Notification.Name("UpdateUserManager"), object: nil)
                        UserDefaults.standard.set(user.character, forKey: "UserCharacter")
                        UserDefaults.standard.set(user.uid, forKey: "UserToken")
                    }
                } catch {
                    print(error)
                    return
                }
                
            }
        }
    }
    
    func fetchCurrentUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").document(uid).getDocument() { (document, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let document = document else { return }
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
     
    func fetchSpecificCraftsmanProfolio(uid: String, completion: @escaping (Result<[Profolio], Error>) -> Void) {
        db.collection("users").document(uid).collection("Profolio").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let querySnapShot = querySnapshot else { return }
                var allPortfolio: [Profolio] = []
                querySnapShot.documents.forEach { document in
                    do {
                        if let portfolio = try document.data(as: Profolio.self, decoder: Firestore.Decoder()) {
                            allPortfolio.append(portfolio)
                        }
                    } catch{
                        completion(.failure(error))
                        return
                    }
                }
                completion(.success(allPortfolio))
            }
        }
    }
    
    //更新用戶大頭貼
    func updateUserImage(uid: String, img: String, completion: @escaping (() -> Void)) {
        db.collection("users").document(uid).setData(["img": img], merge: true) { err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Document successfully updated")
                completion()
            }
        }
    }
    
    //更新用戶背景照片
    func updateUserbackgroundImg(uid: String, backgroundImg: String, completion: @escaping (() -> Void) ) {
        db.collection("users").document(uid).setData(["backgroundImg": backgroundImg], merge: true) { err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Document successfully updated")
                completion()
            }
        }
    }
    
    //更新用戶自己貼文
    func updateUserSelfPost(uid: String, selfPost: [DocumentReference]) {
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
    
    //更新用戶收藏貼文
    func updateUserLovePost(uid: String, lovePost: [DocumentReference]) {
        db.collection("users").document(uid).updateData([
            "lovePost": lovePost
        ]) { err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    //更新用戶名稱
    func updateUserName(uid: String, name: String) {
        db.collection("users").document(uid).updateData([
            "name": name
        ]) { err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    //更新用戶信箱
    func updateUserEmail(uid: String, email: String) {
        db.collection("users").document(uid).updateData([
            "email": email
        ]) { err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    //更新用戶封鎖者名單
    func updateBlockUser(blockUser: [String]) {
        guard let user = UserManager.shared.user else { return }
        db.collection("users").document(user.uid).updateData([
            "blockUser": blockUser
        ]) { err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Document successfully updated")
                self.fetchCurrentUser(uid: user.uid)
            }
        }
    }
    
}
