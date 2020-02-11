//
//  ArticleViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/1/22.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var newPostBtn: UIButton!
    
    var articlesData: [Article] = [] {
        didSet {
            articleTableView.reloadData()
        }
    }
    
    func getData() {
        ArticleManager.shared.fetchAllPost(completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let articles):
                strongSelf.articlesData = articles
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func searchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "想找什麼呢..."
        navigationItem.titleView = searchBar
        
        let layoutBtn = UIBarButtonItem(image: UIImage.asset(.Icons_24px_CollectionView), style: .plain, target: self, action: #selector(changeLayout))
        let filterBtn = UIBarButtonItem(image: UIImage.asset(.Icons_24px_Filter), style: .plain, target: self, action: #selector(setfilter))
        navigationItem.rightBarButtonItems = [layoutBtn, filterBtn]
        navigationController?.navigationBar.barTintColor = UIColor.assetColor(.mainColor)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setTableView() {
        articleTableView.delegate = self
        articleTableView.dataSource = self
        articleTableView.lk_registerCellWithNib(identifier: String(describing: ArticleTableViewCell.self), bundle: nil)
    }
    
    func setNewPost() {
        newPostBtn.setImage(UIImage.asset(.Icons_24px_NewPost), for: .normal)
        newPostBtn.tintColor = .white
        newPostBtn.backgroundColor = UIColor.brown
        newPostBtn.layer.cornerRadius = newPostBtn.frame.size.width / 2
    }
    
    func getCurrentUser() {
        guard let uid = UserDefaults.standard.string(forKey: "UserToken") else { return }
        UserManager.shared.fetchCurrentUser(uid: uid, completion: { result in
            switch result {
                
            case .success(let user):
                
                UserManager.shared.userInfo = user
            
            case .failure(let error):
                
                print(error)
            }
        })
    }
    
    @objc func changeLayout() {
        
    }
    
    @objc func setfilter() {
        
    }
    
    @IBAction func createNewPost(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Article", bundle: nil)
        guard let newPostViewController = storyboard.instantiateViewController(withIdentifier: "NewPostViewController") as? NewPostViewController else { return }
        guard UserDefaults.standard.string(forKey: "UserToken") != nil else {
            
            let alertController = UIAlertController(title: "錯誤", message: "訪客無法發表文章", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
            return 
        }
        navigationController?.pushViewController(newPostViewController, animated: true)
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        searchBar()
        setNewPost()
        getCurrentUser()
    }
}

extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleTableViewCell.self), for: indexPath) as? ArticleTableViewCell else { return UITableViewCell() }
        let article = articlesData[indexPath.row]
        article.author.getDocument(completion: { (document, error) in
            if let error = error {
                print(error)
            } else {
                guard let document = document else { return }
                do {
                    if let author = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                        cell.fillData(authorImgURLString: author.img,
                                      titleLabel: article.title,
                                      nameTimeLabel: "\(article.authorName) | \(article.createTimeString)",
                                      contentLabel: article.content)
                    }
                } catch{
                    print(error)
                    return
                }
            }
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Article", bundle: nil)
        guard let readPostViewController = storyboard.instantiateViewController(withIdentifier: "ReadPostViewController") as? ReadPostViewController else { return }
        readPostViewController.article = articlesData[indexPath.row]
        navigationController?.pushViewController(readPostViewController, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
}
