//
//  ReadPostViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/5.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class ArticleHandler {
    
    var authorName: String
    var authorLogoURLString: String?
    let createTimeString: String
    let content: String
    let comments: [CommentHandler]
    
    init(authorName: String, authorLogoURLString: String?, createTimeString: String, content: String, comments: [CommentHandler]) {
        self.authorName = authorName
        self.authorLogoURLString = authorLogoURLString
        self.createTimeString = createTimeString
        self.content = content
        self.comments = comments
    }
}

class ReplyHandler {
    
    var authorName: String
    var authorLogoURLString: String?
    let createTimeString: String
    let content: String
    let comments: [CommentHandler]
    
    init(authorName: String, authorLogoURLString: String?, createTimeString: String, content: String, comments: [CommentHandler]) {
        self.authorName = authorName
        self.authorLogoURLString = authorLogoURLString
        self.createTimeString = createTimeString
        self.content = content
        self.comments = comments
    }
//    init(reply: Reply, comment: [CommentHandler]) {
//        reply.author.getDocument(completion: { [weak self] (document, err) in
//            guard let strongSelf = self else { return }
//            if let err = err {
//                print(err)
//            } else {
//                guard let document = document else { return }
//                do {
//                    if let replyAuthor = try document.data(as: User.self, decoder: Firestore.Decoder()) {
//                        strongSelf.authorName = replyAuthor.name
//                        strongSelf.authorLogoURLString = replyAuthor.img
//                    }
//                } catch{
//                    print(error)
//                    return
//                }
//            }
//
//        })
//
//        self.createTimeString = reply.createTimeString
//        self.content = reply.content
//        self.comments = comment
//    }
}

class CommentHandler {
    var authorName: String
    var authorLogoURLString: String?
    let createTimeString: String
    let content: String
    
    init (authorName: String, authorLogoURLString: String?, createTimeString: String, content: String) {
        self.authorName = authorName
        self.authorLogoURLString = authorLogoURLString
        self.createTimeString = createTimeString
        self.content = content
    }
//
//    init(comment: Comment) {
//        self.createTimeString = comment.createTimeString
//        self.content = comment.content
//        self.authorName = ""
//        self.authorLogoURLString = ""
//
//        comment.author.getDocument(completion: { (document, err) in
//            if let err = err {
//                print(err)
//            } else {
//                guard let document = document else { return }
//                do {
//                    if let commentAuthor = try document.data(as: User.self, decoder: Firestore.Decoder()) {
//                        self.authorName = commentAuthor.name
//                        self.authorLogoURLString = commentAuthor.img
//                    }
//                } catch{
//                    print(error)
//                    return
//                }
//            }
//
//        })
//    }
}

class ReadPostViewController: UIViewController {
    
    @IBOutlet weak var readPostTableView: UITableView!
    var article: Article?
    var mainPost: ArticleHandler?
    var replys: [Reply] = [] {
        didSet {
            readPostTableView.reloadData()
        }
    }
    
    let group = DispatchGroup()

    let bottomView = UINib(nibName: "ReadPostBottomView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! ReadPostBottomView
    
    func setTableView() {
        readPostTableView.delegate = self
        readPostTableView.dataSource = self
        readPostTableView.lk_registerCellWithNib(identifier: String(describing: ReadPostTableViewCell.self), bundle: nil)
    }
    
    func setBottomView() {
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
    
    func setBottomViewAction() {
        bottomView.moreBtn.addTarget(self, action: #selector(moreVC), for: .touchUpInside)
        bottomView.replyBtn.addTarget(self, action: #selector(replyVC), for: .touchUpInside)
    }
    
    func setNavigationBar() {
        navigationItem.title = "文章title"
        let btn = UIButton()
        btn.setTitle("Back", for: .normal)
        btn.setImage(UIImage.asset(.Icons_24px_Back02), for: .normal)
        btn.sizeToFit()
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(backToArticle), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    func getArticleInfo() {
        group.notify(queue: DispatchQueue.main) {
            self.readPostTableView.reloadData()
        }
        //拿樓主資訊及其文章
        guard let article = article else { return }
        var comments: [Comment] = []
        article.author.getDocument(completion: {[weak self] (document, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                print(error)
            } else {
                guard let document = document else { return }
                do {
                    if let author = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                        //拿樓主的留言
                        ArticleManager.shared.db.collection("article").document(article.postID).collection("comments").getDocuments(completion: { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                guard let querySnapShot = querySnapshot else { return }
                                for document in querySnapShot.documents {
                                    do {
                                        if var comment = try document.data(as: Comment.self, decoder: Firestore.Decoder()) {
                                            comment.author.getDocument(completion: { (document, error) in
                                                if let error = error {
                                                    print(error)
                                                } else {
                                                    guard let document = document else { return }
                                                    do {
                                                        if let commentAuthor = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                                                            
                                                            comment.authorObject = commentAuthor
                                                            
                                                            comments.append(comment)
                                                        }
                                                    } catch{
                                                        print(error)
                                                        return
                                                    }
                                                }
                                                
                                            })
                                        }
                                    } catch {
                                        print(error)
                                        return
                                    }
                                }
                                strongSelf.replys.insert(Reply(author: article.author,
                                                    authorObject: author,
                                                    content: article.content,
                                                    createTime: article.createTime,
                                                    replyID: article.postID), at: 0)
                            }
                            
                        })
                    }
                } catch{
                    print(error)
                    return
                }
            }
        })
        
        //拿全部回覆
        ArticleManager.shared.db.collection("article").document(article.postID).collection("replys").getDocuments(completion:
            { [weak self] (querySnapshot, err) in
                guard let strongSelf = self else { return }
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let querySnapShot = querySnapshot else { return }
                for document in querySnapShot.documents {
                    var replyAuthor: User?
                    do {
                        //拿每一個回覆的作者資訊
                        if let reply = try document.data(as: Reply.self, decoder: Firestore.Decoder()) {
                            reply.author.getDocument(completion: {
                                (document, error) in
                                if let error = error {
                                    print(error)
                                } else {
                                    guard let document = document else { return }
                                    do {
                                        if let replyAuthorInfo = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                                            replyAuthor = replyAuthorInfo
                                            //拿取每一個回覆的全部留言
                                            ArticleManager.shared.db.collection("replys").document(reply.replyID).collection("comments").getDocuments(completion: { (querySnapshot, err) in
                                                if let err = err {
                                                    print("Error getting documents: \(err)")
                                                } else {
                                                    guard let querySnapShot = querySnapshot else { return }
                                                    var replyComments: [Comment] = []
                                                    //拿每一個留言的作者姓名與大頭貼
                                                    for document in querySnapShot.documents {
                                                        do {
                                                            if var comment = try document.data(as: Comment.self, decoder: Firestore.Decoder()) {
                                                                comment.author.getDocument(completion: { (document, error) in
                                                                    if let error = error {
                                                                        print(error)
                                                                    } else {
                                                                        guard let document = document else { return }
                                                                        do {
                                                                            if let commentAuthor = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                                                                                comment.authorObject = commentAuthor
                                                                                replyComments.append(comment)
                                                                            }
                                                                        } catch{
                                                                            print(error)
                                                                            return
                                                                        }
                                                                    }
                                                                    
                                                                })
                                                            }
                                                        } catch {
                                                            print(error.localizedDescription)
                                                            return
                                                        }
                                                    }
                                                    strongSelf.replys.append(Reply(author: reply.author,
                                                                        authorObject: replyAuthor,
                                                                        content: reply.content,
                                                                        createTime: reply.createTime,
                                                                        replyID: reply.replyID))
                                                }
                                            })
                                        }
                                    } catch{
                                        print(error)
                                        return
                                    }
                                }
                            })
                            
                        }
                    } catch {
                        print(error)
                        return
                    }
                }
            }
        })
        
    }
    
    
    @objc func backToArticle() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func moreVC() {
        let storyboard = UIStoryboard(name: "Article", bundle: nil)
        guard let moreViewController = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as? MoreViewController else { return }
        present(moreViewController, animated: true, completion: nil)
    }
    
    @objc func replyVC() {
        let storyboard = UIStoryboard(name: "Article", bundle: nil)
        guard let replyViewController = storyboard.instantiateViewController(withIdentifier: "ReplyViewController") as? ReplyViewController else { return }
        navigationController?.pushViewController(replyViewController, animated: true)
    }
    
    @objc func singleTap() {
        let storyboard = UIStoryboard(name: "Article", bundle: nil)
        guard let replyViewController = storyboard.instantiateViewController(withIdentifier: "ReplyViewController") as? ReplyViewController else { return }
        navigationController?.pushViewController(replyViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getArticleInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setNavigationBar()
        setBottomView()
        setBottomViewAction()
    }
}


extension ReadPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReadPostTableViewCell.self), for: indexPath) as? ReadPostTableViewCell else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            cell.logoImg.loadImage(replys[indexPath.row].authorObject?.img, placeHolder: UIImage(systemName: "person.circle"))
            cell.floorTimeLabel.text = "樓主 | \(replys[indexPath.row].createTimeString)"
            cell.contentLabel.text = replys[indexPath.row].content
            cell.nameLabel.text = replys[indexPath.row].authorObject?.name
        default:
            cell.logoImg.loadImage(replys[indexPath.row].authorObject?.img, placeHolder: UIImage(systemName: "person.circle"))
            cell.floorTimeLabel.text = "\(indexPath.row)樓 | \(replys[indexPath.row].createTimeString)"
            cell.contentLabel.text = replys[indexPath.row].content
            cell.nameLabel.text = replys[indexPath.row].authorObject?.name
        }
        return cell
    }
    
}
