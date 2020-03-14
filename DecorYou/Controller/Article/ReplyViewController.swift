//
//  ReplyViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/5.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class ReplyViewController: UIViewController {
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var thisMainArticle: Article?
    var parentVC: ReadPostViewController?
    var replyContent: [NewPostData] = []
    
    func configureNaviBar() {
        navigationItem.title = "回覆文章"
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "PingFangTC-Medium", size: 16)!]
        
        let rightBtn = UIBarButtonItem(title: "送出", style: .plain, target: self, action: #selector(createPost))
        let leftBtn = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelPost))
        
        navigationItem.rightBarButtonItem = rightBtn
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.leftBarButtonItem = leftBtn
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    func setOutletContent() {
        
        logoImg.layer.cornerRadius = logoImg.frame.size.width / 2
        
    }
    
    func uploadImgStorage(replyID: String,
                          img: UIImage,
                          index: Int,
                          completion: @escaping (Result<String, Error>) -> Void) {
        
        let storageRef = Storage.storage().reference().child("reply").child("\(replyID)-\(index).jpeg")

        if let uploadData = img.jpegData(compressionQuality: 0.5) {
            // 這行就是 FirebaseStorage 關鍵的存取方法。
            storageRef.putData(uploadData, metadata: nil, completion: { (_, error) in

                if error != nil {

                    // 若有接收到錯誤，我們就直接印在 Console 就好，在這邊就不另外做處理。
                    print("Error: \(error!.localizedDescription)")
                    return
                }
                
                //將圖片的URL傳出去
                storageRef.downloadURL(completion: {(url, _) in
                    guard let imgURL = url?.absoluteString else { return }
                    completion(.success(imgURL))
                })
            })
        }
    }
    
    func sendPost() {
        
        //建立reply物件所需資料
        guard let mainArticle = thisMainArticle else { return }
        
        let newReply = ArticleManager.shared.dbF.collection("article").document("\(mainArticle.postID)").collection("replys").document()
        
        guard let uid = UserDefaults.standard.string(forKey: "UserToken") else { return }
        
        let authorRef = UserManager.shared.dbF.collection("users").document("\(uid)")
        
        //將文字與圖片依序放入content array，若遇到圖片則先插入空白文字
        var content: [String] = []
        
        for order in 0..<replyContent.count {
        
            guard let newPostText = replyContent[order] as? NewPostTextView else {
                
                content.append("")
                
                continue
                
            }
            
            content.append(newPostText.text)
        }
        
        //圖片網址依序放入content array
        let group = DispatchGroup()
        
        for order in 0..<replyContent.count {
            
            //檢查articleContent的element是屬於圖片還是文字資料
            guard let newPostImage = replyContent[order] as? NewPostImage else {
                
                continue
                
            }
            
            //上傳圖片至firebase Storage，並取回網址
            group.enter()
            uploadImgStorage(replyID: newReply.documentID,
                             img: newPostImage.image,
                             index: order,
                             completion: { result in
                                switch result {
                                case.success(let url):
                                    content[order] = url
                                    group.leave()
                                case.failure(let error):
                                    print(error)
                                    group.leave()
                                }
            })
            
        }
        
        //網址全部回來之後再上傳
        group.notify(queue: .main) { [weak self] in
            
            guard let strongSelf = self else { return }
            
            let reply = Reply(author: authorRef,
                              content: content,
                              createTime: Date(),
                              replyID: newReply.documentID)
            
            ArticleManager.shared.replyPost(postID: mainArticle.postID, replyCount: mainArticle.replyCount + 1, newReplyID: newReply.documentID, reply: reply)
            
            strongSelf.parentVC?.getReplys()
            
            strongSelf.parentVC?.tableView.reloadData()
            
            strongSelf.navigationController?.popViewController(animated: true)
                
        }
        
    }
    
    func setLayoutDefault() {
        
        nameLabel.text = UserManager.shared.user?.name
        
        titleLabel.text = "Re: \(thisMainArticle!.title)"
        
        logoImg.loadImage(UserManager.shared.user?.img, placeHolder: UIImage(systemName: "person.crop.circle"))
        
        logoImg.tintColor = .lightGray
        
    }
    
    @objc func createPost() {
        
        sendPost()
        
    }
    
    @objc func cancelPost() {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let textViewVC = segue.destination as? TextViewController else { return }
    
        textViewVC.delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNaviBar()
        
        setOutletContent()
        
        setLayoutDefault()
        
    }
}

extension ReplyViewController: TextViewControllerDelegate {
    
    func passToParentVC(_ textViewController: TextViewController) {
        
        replyContent = textViewController.content
        
    }
    
}
