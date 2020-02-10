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

class ReadPostViewController: UIViewController {
    
    @IBOutlet weak var readPostTableView: UITableView!
    var article: Article?
    var replys: [Reply] = []
    
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
        let group0 = DispatchGroup()
        let group1 = DispatchGroup()
        let group2 = DispatchGroup()
        let group3 = DispatchGroup()
        let group4 = DispatchGroup()
        let group5 = DispatchGroup()
        let group6 = DispatchGroup()
        let queue0 = DispatchQueue(label: "queue0")
        let queue1 = DispatchQueue(label: "queue1")
        let queue2 = DispatchQueue(label: "queue2")
        let queue3 = DispatchQueue(label: "queue3")
        let queue4 = DispatchQueue(label: "queue4")
        let queue5 = DispatchQueue(label: "queue5")
        let queue6 = DispatchQueue(label: "queue6")
        
        //拿樓主資訊及其文章
        guard let article = article else { return }
        /*
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
                                group0.enter()
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
                                                            group0.leave()
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
                                group0.notify(queue: queue0) {
                                    strongSelf.replys.insert(Reply(author: article.author,
                                                        authorObject: author,
                                                        content: article.content,
                                                        createTime: article.createTime,
                                                        replyID: article.postID,
                                                        comments: comments), at: 0)
                                }
                            }
                            
                        })
                    }
                } catch{
                    print(error)
                    return
                }
            }
        })
        */
        //MARK: -- 拿樓主文章的留言
        var comments: [Comment] = []
        group0.enter()
        ArticleManager.shared.db.collection("article").document(article.postID).collection("comments").getDocuments(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let querySnapShot = querySnapshot else { return }
                
                for document in querySnapShot.documents {
                    do {
                        if let comment = try document.data(as: Comment.self, decoder: Firestore.Decoder()) {
                            comments.append(comment)
                            
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            group0.leave()
        })
        
        //MARK: -- 拿樓主文章留言的作者資訊
        group1.enter()
        group0.notify(queue: queue0) {
            
            for order in 0...comments.count - 1 {
                group1.enter()
                comments[order].author.getDocument(completion: { (document, err) in
                    guard let document = document else { return }
                    do {
                        if let author = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                            comments[order].authorObject = author
                            group1.leave()
                        }
                    } catch {
                        print(error)
                        return
                    }
                    
                })
            }
            group1.leave()
        }
        
        //MARK: -- 拿樓主個人資訊
        group2.enter()
        group1.notify(queue: queue1) {
            article.author.getDocument(completion: { [weak self] (document, err) in
                guard let strongSelf = self else { return }
                guard let document = document else { return }
                do {
                    if let author = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                        strongSelf.replys.append(Reply(author: article.author, authorObject: author, content: article.content, createTime: article.createTime, replyID: article.postID, comments: comments))
                        group2.leave()
                    }
                } catch {
                    print(error)
                    return
                }
            })
        }
        
        //MARK: -- 拿全部回覆
        group3.enter()
        group2.notify(queue: queue2) {
            ArticleManager.shared.db.collection("article").document(article.postID).collection("replys").getDocuments(completion: { [weak self] (querySnapshot, err) in
                guard let strongSelf = self else { return }
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    guard let querySnapShot = querySnapshot else { return }
                    
                    for document in querySnapShot.documents {
                        do {
                            
                            if let reply = try document.data(as: Reply.self, decoder: Firestore.Decoder()) {
                                strongSelf.replys.append(reply)
                                
                            }
                        } catch {
                            print(error)
                            return
                        }
                    }
                }
                group3.leave()
            })
        }
        //MARK: -- 拿每一個回覆的作者資訊
        group4.enter()
        group3.notify(queue: queue3) {
            if self.replys.count >= 1 {
                for count in 0...self.replys.count - 1 {
                    group4.enter()
                    self.replys[count].author.getDocument(completion: { [weak self] (document, err) in
                        guard let strongSelf = self else { return }
                        guard let document = document else { return }
                        do {
                            if let replyAuthor = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                                strongSelf.replys[count].authorObject = replyAuthor
                                group4.leave()
                            }
                        } catch {
                            print(error)
                            return
                        }
                    })
                }
                group4.leave()
            }
        }
        
        //MARK: -- 拿回覆的留言
        group5.enter()
        group4.notify(queue: queue4) { [weak self] in
            guard let strongSelf = self else { return }
            
            if strongSelf.replys.count >= 1 {
                for order in 0...strongSelf.replys.count - 1 {
                    group5.enter()
                    ArticleManager.shared.db.collection("article").document(article.postID).collection("reply").document(strongSelf.replys[order].replyID).collection("comments").getDocuments(completion: {
                        [weak self] (querySnapShot, err) in
                        guard let strongSelf = self else { return }
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            guard let querySnapShot = querySnapShot else { return }
                            for document in querySnapShot.documents {
                                do {
                                    if let comment = try document.data(as: Comment.self, decoder: Firestore.Decoder()) {
                                        strongSelf.replys[order].comments.append(comment)
                                        
                                    }
                                } catch {
                                    print(error)
                                    return
                                }
                            }
                        }
                    })
                    group5.leave()
                }
                group5.leave()
            }
        }
        
        //MARK: -- 拿留言的作者資訊
        group6.enter()
        group5.notify(queue: queue5) { [weak self] in
            guard let strongSelf = self else { return }
            
            if strongSelf.replys.count >= 1 {
                for order in 0...strongSelf.replys.count - 1 {
                    if strongSelf.replys[order].comments.count >= 1 {
                        for commentOrder in 0...strongSelf.replys[order].comments.count - 1 {
                            group6.enter()
                            strongSelf.replys[order].comments[commentOrder].author.getDocument(completion: { [weak self] (document, err) in
                                guard let document = document else { return }
                                guard let strongSelf = self else { return }
                                do {
                                    if let author = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                                        strongSelf.replys[order].comments[commentOrder].authorObject = author
                                        
                                    }
                                } catch {
                                    print(error)
                                    return
                                }
                            })
                            group6.leave()
                        }
                    }
                }
                group6.leave()
            }
        }
        
        
        group6.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.readPostTableView.reloadData()
        }
        
//        ArticleManager.shared.db.collection("article").document(article.postID).collection("replys").getDocuments(completion:
//            { [weak self] (querySnapshot, err) in
//                guard let strongSelf = self else { return }
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                guard let querySnapShot = querySnapshot else { return }
//                for document in querySnapShot.documents {
//                    var replyAuthor: User?
//                    var replyComments: [Comment] = []
//                    do {
//                        //拿每一個回覆的作者資訊
//                        if let reply = try document.data(as: Reply.self, decoder: Firestore.Decoder()) {
//                            reply.author.getDocument(completion: {
//                                (document, error) in
//                                if let error = error {
//                                    print(error)
//                                } else {
//                                    guard let document = document else { return }
//                                    do {
//                                        if let replyAuthorInfo = try document.data(as: User.self, decoder: Firestore.Decoder()) {
//                                            replyAuthor = replyAuthorInfo
//                                            //拿取每一個回覆的全部留言
//                                            ArticleManager.shared.db.collection("replys").document(reply.replyID).collection("comments").getDocuments(completion: { (querySnapshot, err) in
//                                                if let err = err {
//                                                    print("Error getting documents: \(err)")
//                                                } else {
//                                                    guard let querySnapShot = querySnapshot else { return }
//                                                    //拿每一個留言的作者姓名與大頭貼
//                                                    let innerGroup = DispatchGroup()
//                                                    let innerQueue = DispatchQueue(label: "innerQueue")
//                                                    innerGroup.enter()
//                                                    for document in querySnapShot.documents {
//                                                        do {
//                                                            if var comment = try document.data(as: Comment.self, decoder: Firestore.Decoder()) {
//                                                                comment.author.getDocument(completion: { (document, error) in
//                                                                    if let error = error {
//                                                                        print(error)
//                                                                    } else {
//                                                                        guard let document = document else { return }
//                                                                        do {
//                                                                            if let commentAuthor = try document.data(as: User.self, decoder: Firestore.Decoder()) {
//                                                                                comment.authorObject = commentAuthor
//                                                                                replyComments.append(comment)
//                                                                                innerGroup.leave()
//                                                                            }
//                                                                        } catch{
//                                                                            print(error)
//                                                                            return
//                                                                        }
//                                                                    }
//
//                                                                })
//                                                            }
//                                                        } catch {
//                                                            print(error.localizedDescription)
//                                                            return
//                                                        }
//                                                    }
//                                                    innerGroup.notify(queue: innerQueue) {
//                                                        strongSelf.replys.append(Reply(author: reply.author,
//                                                                                       authorObject: replyAuthor,
//                                                                                       content: reply.content,
//                                                                                       createTime: reply.createTime,
//                                                                                       replyID: reply.replyID,
//                                                                                       comments: replyComments))
//                                                    }
//                                                }
//                                            })
//                                        }
//                                    } catch{
//                                        print(error)
//                                        return
//                                    }
//                                }
//                            })
//                        }
//                    } catch {
//                        print(error)
//                        return
//                    }
//                }
//            }
//        })
//
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        replys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replys[section].comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReadPostTableViewCell.self), for: indexPath) as? ReadPostTableViewCell else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            cell.logoImg.loadImage(replys[indexPath.section].comments[indexPath.row].authorObject?.img, placeHolder: UIImage(systemName: "person.circle"))
            cell.createTimeLabel.text = "\(replys[indexPath.section].comments[indexPath.row].createTimeString)"
            cell.contentLabel.text = replys[indexPath.section].comments[indexPath.row].content
            cell.authorNameLabel.text = replys[indexPath.section].comments[indexPath.row].authorObject?.name
        default:
            cell.logoImg.loadImage(replys[indexPath.section].comments[indexPath.row].authorObject?.img, placeHolder: UIImage(systemName: "person.circle"))
            cell.createTimeLabel.text = "\(replys[indexPath.section].comments[indexPath.row].createTimeString)"
            cell.contentLabel.text = replys[indexPath.section].comments[indexPath.row].content
            cell.authorNameLabel.text = replys[indexPath.section].comments[indexPath.row].authorObject?.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UINib(nibName: "ReadPostTableViewHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! ReadPostTableViewHeaderView
        if section == 0{
            headerView.floorTimeLabel.text = "樓主 | \(replys[section].createTimeString)"
        } else {
            headerView.floorTimeLabel.text = "\(section)樓 | \(replys[section].createTimeString)"
        }
        headerView.authorName.text = replys[section].authorObject?.name
        headerView.logoImg.loadImage(replys[section].authorObject?.img, placeHolder: UIImage(systemName: "person.circle"))
        headerView.contentLabel.text = replys[section].content
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 400
    }
}
