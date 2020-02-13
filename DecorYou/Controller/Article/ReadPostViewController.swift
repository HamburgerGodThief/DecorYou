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
        readPostTableView.sectionHeaderHeight = UITableView.automaticDimension
        readPostTableView.estimatedSectionHeaderHeight = 250
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
        navigationItem.title = article?.title
        navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.white,
         NSAttributedString.Key.font: UIFont(name: "PingFangTC-Medium", size: 18)!]
        let btn = UIButton()
        btn.setImage(UIImage.asset(.Icons_48px_Back01), for: .normal)
        btn.tintColor = UIColor.white
        btn.addTarget(self, action: #selector(backToArticle), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    func getArticleInfo() {
        replys = []
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
        
        //拿樓主資訊及其文章
        guard let article = article else { return }
        
        //MARK: -- 拿樓主文章的留言
        var comments: [Comment] = []
        group0.enter()
        ArticleManager.shared.db.collection("article").document(article.postID).collection("comments").order(by: "createTime", descending: true).getDocuments(completion: { (querySnapshot, err) in
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
            if comments.count > 0 {
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
            } else {
                group1.leave()
            }
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
            ArticleManager.shared.db.collection("article").document(article.postID).collection("replys").order(by: "createTime", descending: false).getDocuments(completion: { [weak self] (querySnapshot, err) in
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
            if self.replys.count > 1 {
                for count in 1...self.replys.count - 1 {
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
            } else {
                group4.leave()
            }
        }
        
        //MARK: -- 拿回覆的留言
        group5.enter()
        group4.notify(queue: queue4) { [weak self] in
            guard let strongSelf = self else { return }
            
            if strongSelf.replys.count > 1 {
                for order in 1...strongSelf.replys.count - 1 {
                    group5.enter()
                    ArticleManager.shared.db.collection("article").document(article.postID).collection("replys").document(strongSelf.replys[order].replyID).collection("comments").order(by: "createTime", descending: true).getDocuments(completion: { (querySnapShot, err) in
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
                        group5.leave()
                    })
                }
                group5.leave()
            } else {
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
                                group6.leave()
                            })
                        }
                    }
                }
                group6.leave()
            } else {
                group6.leave()
            }
        }
        
        
        group6.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.readPostTableView.reloadData()
        }
        
    }
    
    @objc func backToArticle() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func moreVC() {
        let storyboard = UIStoryboard(name: "Article", bundle: nil)
        guard let moreViewController = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as? MoreViewController else { return }
        moreViewController.parentVC = self
        present(moreViewController, animated: true, completion: nil)
    }
    
    @objc func replyVC() {
        let storyboard = UIStoryboard(name: "Article", bundle: nil)
        guard let replyViewController = storyboard.instantiateViewController(withIdentifier: "ReplyViewController") as? ReplyViewController else { return }
        replyViewController.thisMainArticle = article
        replyViewController.parentVC = self
        navigationController?.pushViewController(replyViewController, animated: true)
    }
    
    @objc func sendCommentBelowMain(_ sender: UIButton) {
        guard let footer = sender.superview?.superview as? ReadPostTableViewFooterView else { return }
        if footer.commentTextField.text != nil {
            guard let mainArticle = article else { return }
            let newComment = ArticleManager.shared.db.collection("article").document("\(mainArticle.postID)").collection("comments").document()
            guard let uid = UserDefaults.standard.string(forKey: "UserToken") else { return }
            let authorRef = UserManager.shared.db.collection("users").document("\(uid)")
            let comment = Comment(author: authorRef,
                                  content: footer.commentTextField.text!,
                                  createTime: Date(),
                                  commentID: newComment.documentID)
            ArticleManager.shared.commentMainPost(postID: mainArticle.postID, newCommentID: newComment.documentID, comment: comment)
            getArticleInfo()
            readPostTableView.reloadData()
        }
    }
    
    @objc func sendCommentBelowReply(_ sender: UIButton) {
        guard let footer = sender.superview?.superview as? ReadPostTableViewFooterView else { return }
        guard let order = footer.order else { return }
        if footer.commentTextField.text != nil {
            guard let mainArticle = article else { return }
            let newComment = ArticleManager.shared.db.collection("article").document("\(mainArticle.postID)").collection("replys").document("\(replys[order].replyID)").collection("comments").document()
            guard let uid = UserDefaults.standard.string(forKey: "UserToken") else { return }
            let authorRef = UserManager.shared.db.collection("users").document("\(uid)")
            let comment = Comment(author: authorRef,
                                  content: footer.commentTextField.text!,
                                  createTime: Date(),
                                  commentID: newComment.documentID)
            ArticleManager.shared.commentReplyPost(postID: mainArticle.postID,
                                                   replyID: replys[order].replyID,
                                                   newCommentID: newComment.documentID,
                                                   comment: comment)
            getArticleInfo()
            readPostTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setBottomView()
        setBottomViewAction()
        getArticleInfo()
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UINib(nibName: "ReadPostTableViewFooterView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! ReadPostTableViewFooterView
//        footerView.sendBtn.tag = section
        footerView.order = section
        switch section {
        case 0:
            footerView.sendBtn.addTarget(self, action: #selector(sendCommentBelowMain), for: .touchUpInside)
        default:
            footerView.sendBtn.addTarget(self, action: #selector(sendCommentBelowReply), for: .touchUpInside)
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
}
