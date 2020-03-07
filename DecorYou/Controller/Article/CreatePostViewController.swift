//
//  CreatePostViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/27.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class CreatePostViewController: UIViewController {

    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var articleCatBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var unboxHeight: NSLayoutConstraint!
    @IBOutlet weak var unboxVC: UIView!
    
    var currentUser: User?
    var articleType: String? {
        
        willSet {
            
            if newValue == "開箱" {
                unboxHeight.constant = 50
                unboxVC.alpha = 1
            } else {
                unboxHeight.constant = 0
                unboxVC.alpha = 0
            }
            view.layoutIfNeeded()
            
        }
        
    }
    var unboxTag: UnboxTag?
    var articleContent: [NewPostData] = []
    
    @IBAction func touchArticleCat(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "Article", bundle: nil)
        guard let articleTypeVC = storyboard.instantiateViewController(identifier: "ArticleTypeViewController") as? ArticleTypeViewController else { return }
        articleTypeVC.modalPresentationStyle = .overFullScreen
        articleTypeVC.parentVC = self
        present(articleTypeVC, animated: false, completion: nil)
        
    }
    
    func setIBOutlet() {
        let user = currentUser!
        logoImg.loadImage(user.img)
        nameLabel.text = user.name
        
        logoImg.layer.cornerRadius = logoImg.frame.width / 2
        articleCatBtn.backgroundColor = .clear
        articleCatBtn.layer.cornerRadius = articleCatBtn.frame.height / 2
        articleCatBtn.layer.borderColor = UIColor.assetColor(.mainColor)?.cgColor
        articleCatBtn.layer.borderWidth = 1
    }
    
    func setNavigationBar() {        
        navigationItem.title = "發表文章"
        navigationController?.navigationBar.barTintColor = UIColor.assetColor(.mainColor)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white,
                                                                   .font: UIFont(name: "PingFangTC-Medium", size: 18)!]
        let rightBtn = UIBarButtonItem(title: "送出", style: .plain, target: self, action: #selector(createPost))
        let leftBtn = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelPost))
        rightBtn.tintColor = .white
        leftBtn.tintColor = .white
        navigationItem.rightBarButtonItem = rightBtn
        navigationItem.leftBarButtonItem = leftBtn
    }
    
    func configureAlertController(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func uploadImgStorage(postID: String,
                          img: UIImage,
                          index: Int,
                          completion: @escaping (Result<String, Error>) -> Void) {
        
        let storageRef = Storage.storage().reference().child("unboxing").child("\(postID)-\(index).jpeg")

        if let uploadData = img.jpegData(compressionQuality: 0.5) {
            // 這行就是 FirebaseStorage 關鍵的存取方法。
            storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in

                if error != nil {

                    // 若有接收到錯誤，我們就直接印在 Console 就好，在這邊就不另外做處理。
                    print("Error: \(error!.localizedDescription)")
                    return
                }
                
                //將圖片的URL傳出去
                storageRef.downloadURL(completion: {(url, error) in
                    guard let imgURL = url?.absoluteString else { return }
                    completion(.success(imgURL))
                })
            })
        }
    }
    
    @objc func createPost() {
        //檢查貼文標題有無值
        guard let title = titleTextField.text else {
            configureAlertController(title: "錯誤", message: "標題不可空白")
            return
        }
        
        //檢查貼文類別有無值
        guard let type = articleType else {
            configureAlertController(title: "錯誤", message: "請選擇文章主題")
            return
        }
        
        //檢查內容是不是空的
        if articleContent.isEmpty {
            configureAlertController(title: "錯誤", message: "內容不可空白")
            return
        }
        
        //檢查tag是不是空的
        if type == "開箱" {
        
            guard unboxTag != nil else {
                configureAlertController(title: "錯誤", message: "坪數/地區/風格不可空白")
                return
            }
            
        }
        
        //建立新貼文
        let newPost = ArticleManager.shared.db.collection("article").document()
        guard let uid = UserDefaults.standard.string(forKey: "UserToken") else { return }
        let author = UserManager.shared.db.collection("users").document(uid)
        
        var content: [String] = []
        
        //將文字與圖片依序放入content array，若遇到圖片則先插入空白文字
        for order in 0..<articleContent.count {
        
            guard let newPostText = articleContent[order] as? NewPostTextView else {
                
                content.append("")
                
                continue
                
            }
            
            content.append(newPostText.text)
        }
        
        //圖片網址依序放入content array
        let group = DispatchGroup()
        
        for order in 0..<articleContent.count {
            
            //檢查articleContent的element是屬於圖片還是文字資料
            guard let newPostImage = articleContent[order] as? NewPostImage else {
                
                continue
                
            }
            
            //上傳圖片至firebase Storage，並取回網址
            group.enter()
            uploadImgStorage(postID: newPost.documentID,
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
        
        //檢查貼文類別，產生相對應的article物件
        group.notify(queue: .main) { [weak self] in
            
            guard let strongSelf = self else { return }
            
            if type == "開箱" {
                
                let article = Article(title: title,
                                      type: type,
                                      content: content,
                                      createTime: Date(),
                                      decorateStyle: strongSelf.unboxTag!.style,
                                      location: strongSelf.unboxTag!.location,
                                      loveCount: 0,
                                      replyCount: 0,
                                      postID: newPost.documentID,
                                      size: strongSelf.unboxTag!.size,
                                      collaborator: [],
                                      author: author)
                ArticleManager.shared.addPost(newPostID: newPost.documentID, article: article)
                
            } else {
                
                let article = Article(title: title,
                                      type: type,
                                      content: content,
                                      createTime: Date(),
                                      decorateStyle: nil,
                                      location: nil,
                                      loveCount: 0,
                                      replyCount: 0,
                                      postID: newPost.documentID,
                                      size: nil,
                                      collaborator: [],
                                      author: author)
                ArticleManager.shared.addPost(newPostID: newPost.documentID, article: article)
                
            }
            
            //先讀取User現有的selfPost，再更新User的selfPost
            guard let user = UserManager.shared.user else { return }
            let currentSelfPost = user.selfPost
            let newPostRef = ArticleManager.shared.db.collection("article").document(newPost.documentID)
            var updateSelfPost = currentSelfPost
            updateSelfPost.append(newPostRef)
            UserManager.shared.updateUserSelfPost(uid: uid, selfPost: updateSelfPost)
            strongSelf.dismiss(animated: true, completion: nil)
            strongSelf.tabBarController?.tabBar.isHidden = false
        }
        
        
    }
    
    @objc func cancelPost() {
        
        dismiss(animated: true, completion: nil)
        tabBarController?.tabBar.isHidden = false
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "UnboxingViewController" {
            guard let unboxVC = segue.destination as? UnboxingViewController else { return }
            unboxVC.delegate = self
        } else {
            guard let textViewVC = segue.destination as? TextViewController else { return }
            textViewVC.delegate = self
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setIBOutlet()
        setNavigationBar()
        unboxHeight.constant = 0
        unboxVC.alpha = 0
    }
}

extension CreatePostViewController: UnboxingViewControllerDelegate {
    
    func passDataToCreatePost(unboxingVC: UnboxingViewController) {
        let unboxTagFromVC: UnboxTag = UnboxTag(size: unboxingVC.size,
                                                location: unboxingVC.locationSelected,
                                                style: unboxingVC.styleSelected)
        unboxTag = unboxTagFromVC
    }
    
}

extension CreatePostViewController: TextViewControllerDelegate {
    
    func passToCreateVC(_ textViewController: TextViewController) {
        articleContent = textViewController.content
    }
    
}


