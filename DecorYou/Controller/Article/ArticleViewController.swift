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
    var searchController = UISearchController(searchResultsController: nil)
    
    var shouldShowSearchResults = false
    
    var articlesData: [Article] = []
    var searchResults: [Article] = []
    var finalData: [Article] = []
    
    func getData() {
        let group0 = DispatchGroup()
        let group1 = DispatchGroup()
        let queue0 = DispatchQueue(label: "queue0")
        
        group0.enter()
        ArticleManager.shared.fetchAllPost(completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let articles):
                strongSelf.articlesData = articles
                group0.leave()
            case .failure(let error):
                print(error)
            }
        })
        
        group1.enter()
        group0.notify(queue: queue0) { [weak self] in
            guard let strongSelf = self else { return }
            for order in 0...strongSelf.articlesData.count - 1 {
                group1.enter()
                strongSelf.articlesData[order].author.getDocument(completion: { (document, error) in
                    if let error = error {
                        print(error)
                    } else {
                        guard let document = document else { return }
                        do {
                            if let author = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                                strongSelf.articlesData[order].authorObject = author
                                group1.leave()
                            }
                        } catch{
                            print(error)
                            return
                        }
                    }
                })
            }
            group1.leave()
        }
        
        group1.notify(queue: .main) { [weak self] in
            self?.articleTableView.reloadData()
        }
    }
    
    func configureSearchController() {
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        let searchBar = searchController.searchBar
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.searchTextField.backgroundColor = UIColor.assetColor(.darkMainColor)
        
    }
    
    func setNavBar() {
        navigationItem.titleView = searchController.searchBar
        navigationController?.navigationBar.barTintColor = UIColor.assetColor(.mainColor)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        showNavRightButton(shouldShow: true)
    }
    
    func showNavRightButton(shouldShow: Bool) {
        if shouldShow {
            let layoutBtn = UIBarButtonItem(image: UIImage.asset(.Icons_24px_Layout), style: .plain, target: self, action: #selector(changeLayout))
            let filterBtn = UIBarButtonItem(image: UIImage.asset(.Icons_24px_Filter), style: .plain, target: self, action: #selector(setfilter))
            navigationItem.rightBarButtonItems = [layoutBtn, filterBtn]
        } else {
            navigationItem.rightBarButtonItems = nil
        }
    }
    
    func searching(shouldShow: Bool) {
        showNavRightButton(shouldShow: !shouldShow)
        searchController.searchBar.showsCancelButton = shouldShow
    }
    
    func setTableView() {
        articleTableView.separatorStyle = .none
        articleTableView.delegate = self
        articleTableView.dataSource = self
        articleTableView.lk_registerCellWithNib(identifier: String(describing: ArticleTableViewCell.self), bundle: nil)
    }
    
    func setNewPost() {
        newPostBtn.setImage(UIImage.asset(.Icons_24px_NewPost), for: .normal)
        newPostBtn.tintColor = .white
        newPostBtn.backgroundColor = UIColor.black
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
    
    func searchContent(for searchText: String) {
        
        searchResults = articlesData.filter({ (articles) -> Bool in
            let title = articles.title
            let isMatch = title.localizedCaseInsensitiveContains(searchText)
            return isMatch
        })
        
        articleTableView.reloadData()
        
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
        navigationItem.titleView = nil
        navigationController?.pushViewController(newPostViewController, animated: true)
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setNewPost()
        getCurrentUser()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSearchController()
        setNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "想找的關鍵字",
        attributes: [.foregroundColor: UIColor(red: 187, green: 208, blue: 211, alpha: 1)])
    }
}

extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.searchTextField.isEditing {
            return searchResults.count
        } else {
            return articlesData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleTableViewCell.self), for: indexPath) as? ArticleTableViewCell else { return UITableViewCell() }
        let article = (searchController.searchBar.searchTextField.isEditing) ? searchResults[indexPath.row]: articlesData[indexPath.row]
        guard let authorObject = article.authorObject else { return UITableViewCell() }
        cell.fillData(authorImgURLString: authorObject.img,
                      titleLabel: article.title,
                      nameTimeLabel: "\(authorObject.name) | \(article.createTimeString)",
                      contentLabel: article.content)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Article", bundle: nil)
        guard let readPostViewController = storyboard.instantiateViewController(withIdentifier: "ReadPostViewController") as? ReadPostViewController else { return }
        readPostViewController.article = articlesData[indexPath.row]
        navigationItem.titleView = nil
        navigationController?.pushViewController(readPostViewController, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
}

extension ArticleViewController: UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Start editing")
        searchBar.searchTextField.backgroundColor = UIColor.white
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "想找的關鍵字", attributes: [.foregroundColor: UIColor.lightGray])
        searching(shouldShow: true)
        guard let searchText = searchBar.text else { return }
        searchContent(for: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        searchContent(for: searchText)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("End editing")
        guard let searchText = searchBar.text else { return }
        searchContent(for: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Clicked Cancel Btn")
        searchBar.searchTextField.backgroundColor = UIColor.assetColor(.darkMainColor)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "想找的關鍵字",
                                                                             attributes: [.foregroundColor: UIColor(red: 187, green: 208, blue: 211, alpha: 1)])
        searching(shouldShow: false)
        searchController.searchBar.resignFirstResponder()
    }
}
