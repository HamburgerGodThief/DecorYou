//
//  ArticleViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/1/22.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import Foundation
import UIKit

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var newPostBtn: UIButton!
    
    func searchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "想找什麼呢..."
        navigationItem.titleView = searchBar
        
        let layoutBtn = UIBarButtonItem(image: UIImage.asset(.Icons_24px_CollectionView), style: .plain, target: self, action: #selector(changeLayout))
        let filterBtn = UIBarButtonItem(image: UIImage.asset(.Icons_24px_Filter), style: .plain, target: self, action: #selector(setfilter))
        navigationItem.rightBarButtonItems = [layoutBtn, filterBtn]
        navigationController?.navigationBar.backgroundColor = UIColor.brown
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        searchBar()
        setNewPost()
    }
}

extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleTableViewCell.self), for: indexPath) as? ArticleTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Article", bundle: nil)
        guard let readPostViewController = storyboard.instantiateViewController(withIdentifier: "ReadPostViewController") as? ReadPostViewController else { return }
        navigationController?.pushViewController(readPostViewController, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
}
