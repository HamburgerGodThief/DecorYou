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

class ArticleManager {
    
    static let shared = ArticleManager()
    
    private init() {}
    
    lazy var dbF = Firestore.firestore()
    
    //創建貼文
    func addPost(newPostID: String, article: Article) {
        do {
            try dbF.collection("article").document(newPostID).setData(from: article)
        } catch {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    func fetchPostRef(postRef: DocumentReference, completion: @escaping (Result<Article, Error>) -> Void) {
        postRef.getDocument(completion: { (document, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let document = document else { return }
                do {
                    if let article = try document.data(as: Article.self, decoder: Firestore.Decoder()) {
                        completion(.success(article))
                    }
                } catch {
                    print(error)
                    return
                }
            }
        })
    }
    
    //fetch所有文章
    func fetchAllPost(completion: @escaping (Result<[Article], Error>) -> Void) {
        
        dbF.collection("article").order(by: "createTime", descending: true).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let querySnapShot = querySnapshot else { return }
                var articles: [Article] = []
                querySnapShot.documents.forEach { document in
                    do {
                        if let article = try document.data(as: Article.self, decoder: Firestore.Decoder()) {
                            articles.append(article)
                        }
                    } catch {
                        completion(.failure(error))
                        return
                    }
                }
                completion(.success(articles))
            }
        }
    }
    
    //fetch所有文章的作者
    func fetchPostAuthorRef(authorRef: DocumentReference, completion: @escaping (Result<User, Error>) -> Void) {
        
        authorRef.getDocument(completion: { (document, err) in
            
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
        })
    }
    
    //剔除文章作者是當前user的黑名單
    func hideBlockUserPost(nonBlock: [Article]) -> [Article] {
        
        guard let user = UserManager.shared.user else { return nonBlock }
        
        var articles: [Article] = []
                
        articles = nonBlock.map({
            
            var article = $0
            
            if user.blockUser.contains(article.authorObject!.uid) {
                
                for var element in article.content {
                    
                    element = ""
                    
                }
                
                article.content[0] = "該用戶已被你封鎖，你看不見該用戶的訊息"
                
            }
            
            return article
            
        })
        
        return articles
    }
    
    //若回文作者是當前user的黑名單，則替換文字
    func hideBlockUserReplys(allReply: [Reply]) -> [Reply] {
        
        guard let user = UserManager.shared.user else { return allReply }
        
        var replys: [Reply] = []
        
        replys = allReply.map({
            
            var reply = $0
            
            if user.blockUser.contains(reply.authorObject!.uid) {
                
                reply.content = ["該用戶已被你封鎖，你看不見該用戶的訊息"]
                
            }
            
            return reply
            
        })
        
        return replys
    }
    
    //若留言作者是當前user的黑名單，則替換文字
    func hideBlockUserComments(allComments: [Comment]) -> [Comment] {
        
        guard let user = UserManager.shared.user else { return allComments }
        
        var comments: [Comment] = []
        
        comments = allComments.map({
            
            var comment = $0
                            
            if user.blockUser.contains(comment.authorObject!.uid) {
                
                comment.content = "該用戶已被你封鎖，你看不見該用戶的訊息"
                
            }
            
            return comment
            
        })
        
        return comments
    }
    
    //收藏文章
    func addLovePostCount(postID: String, loveCount: Int) {
        
        dbF.collection("article").document(postID).setData(["loveCount": loveCount], merge: true) { err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
    }
    
    //回覆文章
    func replyPost(postID: String, replyCount: Int, newReplyID: String, reply: Reply) {
        
        do { try dbF.collection("article").document("\(postID)").collection("replys").document(newReplyID).setData(from: reply)
            dbF.collection("article").document(postID).setData(["replyCount": replyCount], merge: true) { err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        } catch {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    //樓主文章的留言
    func commentMainPost(postID: String, newCommentID: String, comment: Comment) {
        do { try dbF.collection("article").document("\(postID)").collection("comments").document(newCommentID).setData(from: comment)
        } catch {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    //回文的留言
    func commentReplyPost(postID: String, replyID: String, newCommentID: String, comment: Comment) {
        do { try dbF.collection("article").document("\(postID)").collection("replys").document(replyID).collection("comments").document(newCommentID).setData(from: comment)
        } catch {
            print("Error writing city to Firestore: \(error)")
        }
    }
}
