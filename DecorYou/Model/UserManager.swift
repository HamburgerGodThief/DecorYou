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
    let lovePost: [DocumentReference]
    let selfPost: [DocumentReference]
    let character: String
    let serviceLocation: [String]
    var serviceCategory: String?
    var select: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case uid, email, name, img, lovePost, selfPost, character, serviceLocation, serviceCategory
    }
}

struct Profolio: Codable {
    
    var livingRoom: [String]
    var dinningRoom: [String]
    var mainRoom: [String]
    var firstRoom: [String]
    var kitchen: [String]
    var bathRoom: [String]
    let createTime: Date
    var createTimeString: String {
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd HH:mm"
        return format.string(from: createTime)
    }
    
    enum CodingKeys: String, CodingKey {
        case livingRoom, dinningRoom, mainRoom, firstRoom, kitchen, bathRoom, createTime
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
                    }
                } catch {
                    print(error)
                    return
                }
            }
        }
    }
    
    func fetchSpecificCraftsmanPortfolio(uid: String, completion: @escaping (Result<[Profolio], Error>) -> Void) {
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
    
    func updateUserImage(uid: String, img: String) {
        db.collection("users").document(uid).setData(["img": img], merge: true) { err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
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
    
    
}
