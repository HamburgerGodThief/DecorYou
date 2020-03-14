//
//  CommentViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/3/8.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class CommentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.delegate = self
            
            tableView.dataSource = self
            
            tableView.sectionHeaderHeight = 80
            
            tableView.estimatedRowHeight = 150
            
            tableView.rowHeight = UITableView.automaticDimension
            
            tableView.lk_registerCellWithNib(identifier: "CommentsTableViewCell", bundle: nil)
                        
            tableView.separatorStyle = .none
            
        }
        
    }
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var textBackground: UIView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    var mainArticleID: String = ""
    
    var replyID: String = ""
    
    var comments: [Comment] = []
    
    var isInitialArticle: Bool = false
    
    var initialCommentCount: Int = 0
    
    func getAuthorInfoInComments() {
                
        let group = DispatchGroup()
        
        for index in 0..<comments.count {
            
            group.enter()
            
            comments[index].author.getDocument(completion: { [weak self] (document, _) in
                
                guard let strongSelf = self else { return }
                
                guard let document = document else { return }
                
                do {
                    
                    if let authorOBJ = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                        
                        strongSelf.comments[index].authorObject = authorOBJ
                        
                    }
                    
                } catch {
                    
                    print(error)
                    
                    return
                }
                
                group.leave()
                
            })
            
        }
        
        group.notify(queue: .main) { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.tableView.reloadData()
                        
        }
        
    }
    
    func configureBottomView() {
        
        textBackground.layer.cornerRadius = 10
        
        textBackground.layer.borderColor = UIColor.assetColor(.mainColor)?.cgColor
        
        textBackground.layer.borderWidth = 2
        
    }
    
    @IBAction func sendCommentMessage(_ sender: Any) {
        
        if textField.text != nil {
            
            //拿到currentUser ref，作為authorRef
            guard let uid = UserDefaults.standard.string(forKey: "UserToken") else { return }
            
            let authorRef = UserManager.shared.dbF.collection("users").document("\(uid)")
            
            var newCommentRef: DocumentReference?
            
            //先判斷現在commentVC是樓主的還是其他樓層的，才能將留言放入正確位置
            if isInitialArticle {
                
                newCommentRef = ArticleManager.shared.dbF.collection("article").document(mainArticleID).collection("comments").document()
                
                let comment = Comment(author: authorRef,
                                      content: textField.text!,
                                      createTime: Date(),
                                      commentID: newCommentRef!.documentID)
                
                ArticleManager.shared.commentMainPost(postID: mainArticleID,
                                                      newCommentID: newCommentRef!.documentID,
                                                      comment: comment)
                
                comments.insert(comment, at: 0)
                
                comments[0].authorObject = UserManager.shared.user
                
            } else {
                
                newCommentRef = ArticleManager.shared.dbF.collection("article").document(mainArticleID).collection("replys").document(replyID).collection("comments").document()
                
                let comment = Comment(author: authorRef,
                                      content: textField.text!,
                                      createTime: Date(),
                                      commentID: newCommentRef!.documentID)
                
                ArticleManager.shared.commentReplyPost(postID: mainArticleID,
                                                       replyID: replyID,
                                                       newCommentID: newCommentRef!.documentID,
                                                       comment: comment)
                
                comments.insert(comment, at: 0)
                
                comments[0].authorObject = UserManager.shared.user
                
            }
            
            //過濾掉黑名單訊息
            comments = ArticleManager.shared.hideBlockUserComments(allComments: comments)
            
            //讓鍵盤下去，並且清空textField裡面文字
            view.endEditing(true)
            
            textField.text = nil
            
            tableView.reloadData()
            
        }
        
    }
    
    @objc func presentReportAlert(_ sender: UIButton) {
        
        guard var user = UserManager.shared.user else {
            
            SwiftMes.shared.showVistorRelated(title: "訪客無法使用此功能", body: "請先登入才能檢舉或封鎖", seconds: 1.5)
            
            return
            
        }
        
        let reportAlertController = UIAlertController(title: "封鎖或檢舉此用戶", message: "請選擇要執行的項目", preferredStyle: .actionSheet)
        
        // 建立3個 UIAlertAction 的實體，在 UIAlertController actionSheet 的 動作 (action) 與標題

        let reportUserAction = UIAlertAction(title: "檢舉", style: .default) { (_) in
            
            SwiftMes.shared.showSuccessMessage(title: "已成功檢舉該用戶", body: "我們會將此用戶放入觀察名單", seconds: 1.5)
        }
        
        //拿取user現有封鎖清單，把被封鎖人的uid append進去再上傳
        let blockUserAction = UIAlertAction(title: "封鎖", style: .default) { [weak self] (_) in
            
            guard let strongSelf = self else { return }
            
            user.blockUser.append(strongSelf.comments[sender.tag].authorObject!.uid)
            
            UserManager.shared.updateBlockUser(blockUser: user.blockUser)
                            
            SwiftMes.shared.showSuccessMessage(title: "已成功封鎖該用戶", body: "以後都看不到該用戶發布的內容囉", seconds: 1.5)
            
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
            reportAlertController.dismiss(animated: true, completion: nil)
        }

        // 將上面3個 UIAlertAction 動作加入 UIAlertController
        reportAlertController.addAction(reportUserAction)
        reportAlertController.addAction(blockUserAction)
        reportAlertController.addAction(cancelAction)

        // 當使用者按下 uploadBtnAction 時會 present 剛剛建立好的四個 UIAlertAction 動作
        present(reportAlertController, animated: true, completion: nil)
    }
    
    @objc func dismissCommentVC(_ sender: UIButton) {
        
        if initialCommentCount < comments.count {
        
            guard let tab = presentingViewController as? STTabBarViewController else { return }
            
            guard let nav = tab.selectedViewController as? UINavigationController else { return }
            
            guard let readVC = nav.viewControllers[1] as? ReadPostViewController else { return }
            
            readVC.getReplys()
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAuthorInfoInComments()
        
        configureBottomView()
        
        tableView.layer.cornerRadius = 30
        
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        initialCommentCount = comments.count

    }
    
}

extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as? CommentsTableViewCell else { return UITableViewCell() }
        
        cell.authorNameLabel.text = comments[indexPath.row].authorObject?.name
        
        cell.contentLabel.text = comments[indexPath.row].content
        
        cell.createTimeLabel.text = comments[indexPath.row].intervalString
        
        cell.logoImg.loadImage(comments[indexPath.row].authorObject?.img)
        
        cell.reportBtn.tag = indexPath.row
        
        cell.reportBtn.addTarget(self, action: #selector(presentReportAlert), for: .touchUpInside)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        
        headerView.backgroundColor = UIColor.assetColor(.shadowLightGray)
        
        let label = UILabel()
        label.text = "留言(\(comments.count))"
        headerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        let button = UIButton()
        button.setImage(UIImage.asset(.Icons_24px_Close), for: .normal)
        button.tintColor = UIColor.darkGray
        button.addTarget(self, action: #selector(dismissCommentVC), for: .touchUpInside)
        headerView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15).isActive = true
        button.heightAnchor.constraint(equalTo: headerView.heightAnchor, constant: -10).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        
        let line = UIView()
        line.backgroundColor = .lightGray
        headerView.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        
        line.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.widthAnchor.constraint(equalTo: headerView.widthAnchor).isActive = true
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
        
    }
    
}
