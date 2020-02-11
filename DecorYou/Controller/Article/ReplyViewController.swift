//
//  ReplyViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/5.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var replyContentTextView: UITextView!
    var thisMainArticle: Article?
    var parentVC: ReadPostViewController?
    
    func setNavigationBar() {
        navigationItem.title = "回覆文章"
        let rightBtn = UIBarButtonItem(title: "送出", style: .plain, target: self, action: #selector(createPost))
        let leftBtn = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelPost))
        navigationItem.rightBarButtonItem = rightBtn
        navigationItem.leftBarButtonItem = leftBtn
    }
    
    func setOutletContent() {
        logoImg.layer.cornerRadius = logoImg.frame.size.width / 2
        nameLabel.text = "User name"
    }
    
    @objc func createPost() {
        sendPost()
        parentVC?.readPostTableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelPost() {
        navigationController?.popViewController(animated: true)
    }
    
    func sendPost() {
        guard let mainArticle = thisMainArticle else { return }
        let newReply = ArticleManager.shared.db.collection("article").document("\(mainArticle.postID)").collection("replys").document()
        guard let uid = UserDefaults.standard.string(forKey: "UserToken") else { return }
        let authorRef = UserManager.shared.db.collection("users").document("\(uid)")
        let reply = Reply(author: authorRef, content: replyContentTextView.text, createTime: Date(), replyID: newReply.documentID)
        ArticleManager.shared.replyPost(postID: mainArticle.postID, newReplyID: newReply.documentID, reply: reply)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setOutletContent()
        nameLabel.text = UserManager.shared.userInfo?.name
        titleLabel.text = "Re: \(thisMainArticle!.title)"
        logoImg.loadImage(UserManager.shared.userInfo?.img)
    }
}
