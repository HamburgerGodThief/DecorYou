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
    // swiftlint:disable force_cast
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.delegate = self
            
            tableView.dataSource = self
            
            tableView.sectionHeaderHeight = 80
            
            tableView.estimatedRowHeight = 150
            
            tableView.rowHeight = UITableView.automaticDimension
            
            tableView.lk_registerCellWithNib(identifier: "TextTableViewCell", bundle: nil)
            
            tableView.lk_registerCellWithNib(identifier: "ImageTableViewCell", bundle: nil)
            
            tableView.separatorStyle = .none
            
        }
        
    }
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var article: Article?
    var replys: [Reply] = []
    let leftbtn = UIButton()
    let rightbtn = UIButton()
    var userLovePost: [Article] = []
    var isLovePost: Bool = false
    let bottomView = UINib(nibName: "ReadPostBottomView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! ReadPostBottomView
    // swiftlint:enable force_cast
    
    func setBottomView() {
                
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 65)
        ])
        
        bottomConstraint.isActive = false
        
        tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        
    }
    
    func setBottomViewAction() {
        
        bottomView.moreBtn.addTarget(self, action: #selector(moreVC), for: .touchUpInside)
        
        bottomView.replyBtn.addTarget(self, action: #selector(replyVC), for: .touchUpInside)
        
    }
    
    func setNavigationBar(isLovePost: Bool) {
        navigationItem.title = article?.title
        navigationController?.navigationBar.titleTextAttributes =
        [.foregroundColor: UIColor.white,
         .font: UIFont(name: "PingFangTC-Medium", size: 16)!]
        
        leftbtn.setImage(UIImage.asset(.Icons_48px_Back01), for: .normal)
        leftbtn.tintColor = UIColor.white
        leftbtn.addTarget(self, action: #selector(backToArticle), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftbtn)
        
        if isLovePost {
            rightbtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            rightbtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        rightbtn.tintColor = UIColor.white
        rightbtn.addTarget(self, action: #selector(addFavorite), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightbtn)
    }
    
    func checkLovePost() {
        
        guard var user = UserManager.shared.user else { return }
        guard let thisMainArticle = article else { return }
        let thisArticleRef = ArticleManager.shared.dbF.collection("article").document(thisMainArticle.postID)
                    
        user.lovePost = user.lovePost.filter({ lovePostRef -> Bool in
            
            if lovePostRef == thisArticleRef {
                return true
            }
            return false
        })
        
        if user.lovePost.isEmpty {
            
            isLovePost = false
            
        } else {
            
            isLovePost = true
            
        }
        
        setNavigationBar(isLovePost: isLovePost)
    }
    
    func addFavoriteAction() {
        
        guard var user = UserManager.shared.user else { return }
        guard let thisMainArticle = article else { return }
        let thisArticleRef = ArticleManager.shared.dbF.collection("article").document(thisMainArticle.postID)
        
        if isLovePost {
            
            user.lovePost = user.lovePost.filter({ lovePostRef -> Bool in
                
                if lovePostRef != thisArticleRef {
                    return true
                }
                return false
            })
            
            rightbtn.setImage(UIImage(systemName: "heart"), for: .normal)
            SwiftMes.shared.showSuccessMessage(title: "成功", body: "已取消收藏", seconds: 1.5)
            ArticleManager.shared.addLovePostCount(postID: thisMainArticle.postID, loveCount: thisMainArticle.loveCount - 1)
            
        } else {
            
            user.lovePost.append(thisArticleRef)
            rightbtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            SwiftMes.shared.showSuccessMessage(title: "成功", body: "已收藏文章", seconds: 1.5)
            ArticleManager.shared.addLovePostCount(postID: thisMainArticle.postID, loveCount: thisMainArticle.loveCount + 1)
        }
        
        UserManager.shared.updateUserLovePost(uid: user.uid, lovePost: user.lovePost)
        UserManager.shared.fetchCurrentUser(uid: user.uid)
        isLovePost = !isLovePost
        
    }
    // swiftlint:disable all
    func getReplys() {
        
        let loadingVC = presentLoadingVC()
        
        //每次呼叫都先清空舊資料
        replys = []
        
        let group0 = DispatchGroup()
        let group1 = DispatchGroup()
        let group2 = DispatchGroup()
        let group3 = DispatchGroup()
        let group4 = DispatchGroup()
        let queue0 = DispatchQueue(label: "queue0")
        let queue1 = DispatchQueue(label: "queue1")
        let queue2 = DispatchQueue(label: "queue2")
        let queue3 = DispatchQueue(label: "queue3")
        
        //由上一頁傳來的文章(樓主部分)，replys第0個永遠是樓主的
        guard let article = article else { return }
        
        replys.append(Reply(author: article.author,
                            authorObject: article.authorObject,
                            content: article.content,
                            createTime: article.createTime,
                            replyID: article.postID,
                            comments: []))
        
        //拿樓主的留言
        group0.enter()
        ArticleManager.shared.dbF.collection("article").document(article.postID).collection("comments").order(by: "createTime", descending: true).getDocuments(completion: { [weak self] (querySnapshot, err) in
            guard let strongSelf = self else { return }
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let querySnapShot = querySnapshot else { return }
                
                for document in querySnapShot.documents {
                    do {
                        if let comment = try document.data(as: Comment.self, decoder: Firestore.Decoder()) {
                            strongSelf.replys[0].comments.append(comment)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            group0.leave()
        })
        
        // MARK: - 拿樓主個人資訊
        group1.enter()
        group0.notify(queue: queue0) {
            article.author.getDocument(completion: { [weak self] (document, _) in
                guard let strongSelf = self else { return }
                guard let document = document else { return }
                do {
                    if let authorOBJ = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                        strongSelf.replys[0].authorObject = authorOBJ
                        group1.leave()
                    }
                } catch {
                    print(error)
                    return
                }
            })
        }
        
        // MARK: - 拿全部回覆
        group2.enter()
        group1.notify(queue: queue1) {
            ArticleManager.shared.dbF.collection("article").document(article.postID).collection("replys").order(by: "createTime", descending: false).getDocuments(completion: { [weak self] (querySnapshot, err) in
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
                group2.leave()
            })
        }
        
        // MARK: - 拿每一個回覆的作者資訊
        group3.enter()
        group2.notify(queue: queue2) {
            if self.replys.count > 1 {
                for count in 1..<self.replys.count {
                    group3.enter()
                    self.replys[count].author.getDocument(completion: { [weak self] (document, _) in
                        guard let strongSelf = self else { return }
                        guard let document = document else { return }
                        do {
                            if let replyAuthor = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                                strongSelf.replys[count].authorObject = replyAuthor
                                group3.leave()
                            }
                        } catch {
                            print(error)
                            return
                        }
                    })
                }
            }
            group3.leave()
        }
        
        // MARK: - 拿回覆的留言
        group4.enter()
        group3.notify(queue: queue3) { [weak self] in
            guard let strongSelf = self else { return }
            
            if strongSelf.replys.count > 1 {
                for order in 1..<strongSelf.replys.count {
                    group4.enter()
                    ArticleManager.shared.dbF.collection("article").document(article.postID).collection("replys").document(strongSelf.replys[order].replyID).collection("comments").order(by: "createTime", descending: true).getDocuments(completion: { (querySnapShot, err) in
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
                        group4.leave()
                    })
                }
            }
            group4.leave()
            
        }
        
        group4.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.replys = ArticleManager.shared.hideBlockUserReplys(allReply: strongSelf.replys)
            
            loadingVC.dismiss(animated: false, completion: nil)
            
            strongSelf.tableView.reloadData()
            
        }
    }
    // swiftlint:enable all
    
    @objc func backToArticle() {
        guard let articleVC = navigationController?.viewControllers[0] as? ArticleViewController else { return }
        articleVC.getData(shouldShowLoadingVC: true)
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func addFavorite() {
        
        addFavoriteAction()
        
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
    
    @objc func presentReportAlert(_ sender: UIButton) {
        
        guard var user = UserManager.shared.user else {
            
            SwiftMes.shared.showVistorRelated(title: "訪客無法使用此功能", body: "請先登入才能檢舉或封鎖", seconds: 1.5)
            return
            
        }
        
        let reportAlertController = UIAlertController(title: "封鎖或檢舉此用戶", message: "請選擇要執行的項目", preferredStyle: .actionSheet)
        
        // 建立3個 UIAlertAction 的實體
        // 新增 UIAlertAction 在 UIAlertController actionSheet 的 動作 (action) 與標題

        let reportUserAction = UIAlertAction(title: "檢舉", style: .default) { (_) in
            SwiftMes.shared.showSuccessMessage(title: "已成功檢舉該用戶", body: "我們會將此用戶放入觀察名單", seconds: 1.5)
        }
        
        //先拿取user現有封鎖清單，把被封鎖人的uid append進去再上傳
        let blockUserAction = UIAlertAction(title: "封鎖", style: .default) { [weak self] (_) in
            
            guard let strongSelf = self else { return }
            
            user.blockUser.append(strongSelf.replys[sender.tag].authorObject!.uid)
        
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
    
    @objc func presentCommentVC(_ sender: UIButton) {
        
        let storyboard = UIStoryboard.init(name: "Article", bundle: nil)
        
        guard let commentVC = storyboard.instantiateViewController(identifier: "CommentViewController") as? CommentViewController else { return }
        
        commentVC.comments = replys[sender.tag].comments
        
        commentVC.mainArticleID = replys[sender.tag].replyID
        
        commentVC.replyID = replys[sender.tag].replyID
        
        if sender.tag == 0 {
            
            commentVC.isInitialArticle = true
        }
                
        present(commentVC, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBottomView()
        setBottomViewAction()
        getReplys()
        checkLovePost()
    }
}

extension ReadPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        replys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replys[section].content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        if replys[indexPath.section].content[indexPath.row].contains("https://firebasestorage.googleapis") {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as? ImageTableViewCell else { return UITableViewCell() }
            
            cell.photoImg.loadImage(replys[indexPath.section].content[indexPath.row], placeHolder: UIImage())
            
            cell.removeBtn.isHidden = true
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as? TextTableViewCell else { return UITableViewCell() }
            
            cell.textView.text = replys[indexPath.section].content[indexPath.row]
            
            cell.textView.isScrollEnabled = false
            
            cell.textView.isUserInteractionEnabled = false
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = UINib(nibName: "ReadPostTableViewHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? ReadPostTableViewHeaderView else { return nil }
        
        if section == 0 {
            
            headerView.floorTimeLabel.text = "樓主 | \(replys[section].createTimeString)"
            
        } else {
            
            headerView.floorTimeLabel.text = "\(section)樓 | \(replys[section].createTimeString)"
            
        }
        
        headerView.authorName.text = replys[section].authorObject?.name
        
        headerView.logoImg.loadImage(replys[section].authorObject?.img, placeHolder: UIImage(systemName: "person.crop.circle"))
        
        headerView.logoImg.tintColor = .lightGray
        
        headerView.reportBtn.tag = section
        
        headerView.reportBtn.addTarget(self, action: #selector(presentReportAlert), for: .touchUpInside)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 70
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let footerView = UINib(nibName: "ReadPostTableViewFooterView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? ReadPostTableViewFooterView else { return nil }
        
        footerView.moreCommentBtn.addTarget(self, action: #selector(presentCommentVC), for: .touchUpInside)
        
        if replys[section].comments.count == 0 {
            
            footerView.moreCommentBtn.setTitle("發表留言", for: .normal)
            
        } else {
            
            footerView.moreCommentBtn.setTitle("還有\(replys[section].comments.count)則留言", for: .normal)
            
        }
        
        footerView.moreCommentBtn.tag = section
                        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
}
