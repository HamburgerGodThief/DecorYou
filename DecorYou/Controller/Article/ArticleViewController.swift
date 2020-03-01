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
    @IBOutlet weak var searchResultLabel: UILabel!
    
    let transition: CircularTransition = CircularTransition()
    var searchController = UISearchController(searchResultsController: nil)
    var refreshControl = UIRefreshControl()
    var isChangeLayout: Bool = false {
        didSet {
            
            articleTableView.reloadData()
        }
    }
    var isFilter: Bool = false
    var isSearching: Bool = false {
        
        didSet {
            
            searching(shouldShow: isSearching)
            
        }
        
    }
    var allArticle: [Article] = []
    var searchResults: [Article] = []
    var filterResults: [Article] = []
    var finalArticles: [Article] = []
    let itemSpace: CGFloat = 12
    let columnCount: CGFloat = 4
    var collectionItem: [[String]] = []
    
    func getData(shouldShowLoadingVC: Bool) {
        var loadingVC: LoadingViewController?
        if shouldShowLoadingVC {
            loadingVC = presentLoadingVC()
        }
        let group0 = DispatchGroup()
        let group1 = DispatchGroup()
        let queue0 = DispatchQueue(label: "queue0")
        //抓全部文章
        group0.enter()
        ArticleManager.shared.fetchAllPost(completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let articles):
                strongSelf.allArticle = articles
                strongSelf.finalArticles = strongSelf.allArticle
                group0.leave()
            case .failure(let error):
                print(error)
            }
        })
        //抓文章的作者
        group1.enter()
        group0.notify(queue: queue0) { [weak self] in
            guard let strongSelf = self else { return }
            for order in 0..<strongSelf.allArticle.count {
                group1.enter()
                strongSelf.allArticle[order].author.getDocument(completion: { (document, error) in
                    if let error = error {
                        print(error)
                    } else {
                        guard let document = document else { return }
                        do {
                            if let author = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                                strongSelf.allArticle[order].authorObject = author
                                strongSelf.finalArticles[order].authorObject = strongSelf.allArticle[order].authorObject
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
            if shouldShowLoadingVC {
                loadingVC!.dismiss(animated: false, completion: nil)
            }
            self?.combineDataForCollectionItem()
            self?.refreshControl.endRefreshing()
            self?.articleTableView.reloadData()
        }
    }
    
    func configureSearchController() {
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.searchTextField.backgroundColor = UIColor.assetColor(.darkMainColor)
    }
    
    func setNavBar() {
        navigationItem.titleView = searchController.searchBar
        navigationController?.navigationBar.barTintColor = UIColor.assetColor(.mainColor)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        
    }
    
    func showNavRightButton(shouldShow: Bool) {
        if shouldShow {
            let layoutBtn = isChangeLayout(isChangeLayout: isChangeLayout)
            let filterBtn = isFiltering(isFilter: isFilter)
            navigationItem.rightBarButtonItems = [filterBtn, layoutBtn]
        } else {
            navigationItem.rightBarButtonItems = nil
        }
    }
    
    func isFiltering(isFilter: Bool) -> UIBarButtonItem {
        if isFilter {
            let filterBtn = UIBarButtonItem(image: UIImage.asset(.Icons_24px_FilterSelected), style: .plain, target: self, action: #selector(configureSlideInFilter))
            return filterBtn
        } else {
            let filterBtn = UIBarButtonItem(image: UIImage.asset(.Icons_24px_Filter), style: .plain, target: self, action: #selector(configureSlideInFilter))
            return filterBtn
        }
    }
    
    func isChangeLayout(isChangeLayout: Bool) -> UIBarButtonItem {
        if isChangeLayout {
            let layoutBtn = UIBarButtonItem(image: UIImage(systemName: "capsule"), style: .plain, target: self, action: #selector(changeLayout))
            layoutBtn.imageInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            return layoutBtn
        } else {
            let layoutBtn = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(changeLayout))
            layoutBtn.imageInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            return layoutBtn
        }
    }
    
    func searching(shouldShow: Bool) {
        
        showNavRightButton(shouldShow: !shouldShow)
        
        searchController.searchBar.showsCancelButton = shouldShow
        
        searchController.searchBar.searchTextField.backgroundColor = shouldShow ? .white : UIColor.assetColor(.darkMainColor)
        
        searchController.searchBar.searchTextField.attributedPlaceholder = shouldShow ?
            NSAttributedString(string: "想找的關鍵字", attributes: [.foregroundColor: UIColor.lightGray]) :
            NSAttributedString(string: "想找的關鍵字", attributes: [.foregroundColor: UIColor(red: 187, green: 208, blue: 211, alpha: 1)])
        
    }
    
    func setTableView() {
        articleTableView.separatorStyle = .none
        articleTableView.delegate = self
        articleTableView.dataSource = self
        articleTableView.lk_registerCellWithNib(identifier: String(describing: ArticleTableViewCell.self), bundle: nil)
        articleTableView.lk_registerCellWithNib(identifier: String(describing: ArticleListTableViewCell.self), bundle: nil)
        articleTableView.estimatedRowHeight = 180
        articleTableView.rowHeight = UITableView.automaticDimension
    }
    
    func setNewPost() {
        newPostBtn.setImage(UIImage.asset(.Icons_24px_NewPost), for: .normal)
        newPostBtn.tintColor = .white
        newPostBtn.backgroundColor = UIColor.black
        newPostBtn.layer.cornerRadius = newPostBtn.frame.size.width / 2
    }
    
    func getCurrentUser() {
        guard let uid = UserDefaults.standard.string(forKey: "UserToken") else { return }
        
        UserManager.shared.fetchCurrentUser(uid: uid)
    }
    
    func searchContent(for searchText: String) {
        
        if isFilter {
            
            searchResults = finalArticles.filter({ (articles) -> Bool in
                let title = articles.title
                let isMatch = title.localizedCaseInsensitiveContains(searchText)
                return isMatch
            })
            
        } else {
            
            searchResults = allArticle.filter({ (articles) -> Bool in
                let title = articles.title
                let isMatch = title.localizedCaseInsensitiveContains(searchText)
                return isMatch
            })
            
        }
        
        finalArticles = searchResults
        
        if finalArticles.isEmpty {
            searchResultLabel.isHidden = false
        } else {
            searchResultLabel.isHidden = true
        }
        
        articleTableView.reloadData()
        
    }
    
    func addRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        articleTableView.refreshControl = refreshControl
    }
    
    func combineDataForCollectionItem () {
        collectionItem = []
        for index in 0..<finalArticles.count {
            collectionItem.append([])
            if finalArticles[index].location != nil {
                collectionItem[index].append(finalArticles[index].location!)
            }
            if finalArticles[index].size != nil {
                collectionItem[index].append(String(finalArticles[index].size!))
            }
            if finalArticles[index].decorateStyle != nil {
                collectionItem[index].append(finalArticles[index].decorateStyle!)
            }
        }
    }
    
    @objc func refreshData() {
        getData(shouldShowLoadingVC: false)
    }
    
    @objc func refreshContent() {
        perform(#selector(refreshData), with: nil, afterDelay: 1.5)
    }
    
    @objc func changeLayout() {
        if isChangeLayout == false {
            articleTableView.separatorStyle = .singleLine
            articleTableView.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
            navigationItem.rightBarButtonItems?[1].image = UIImage(systemName: "capsule")
            isChangeLayout = true
        } else {
            articleTableView.separatorStyle = .none
            navigationItem.rightBarButtonItems?[1].image = UIImage(systemName: "list.bullet")
            isChangeLayout = false
        }
    }
    
    @objc func configureSlideInFilter() {
        searchResultLabel.isHidden = true
        guard let tabBarController = tabBarController as? STTabBarViewController else { return }
        present(tabBarController.filterVC, animated: false, completion: nil)
    }
    
    @IBAction func createNewPost(_ sender: Any) {
        
        guard UserDefaults.standard.string(forKey: "UserToken") != nil else {
            
            let alertController = UIAlertController(title: "錯誤", message: "訪客無法發表文章", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
            return 
        }
        let storyboard = UIStoryboard(name: "Article", bundle: nil)
        guard let newPostViewController = storyboard.instantiateViewController(withIdentifier: "CreatePostViewController") as? CreatePostViewController else { return }
        navigationItem.titleView = nil
        newPostViewController.currentUser = UserManager.shared.user
        newPostViewController.transitioningDelegate = self
        newPostViewController.modalPresentationStyle = .custom
//        present(newPostViewController, animated: true, completion: nil)
        navigationController?.pushViewController(newPostViewController, animated: true)
        tabBarController?.tabBar.isHidden = true
//        let storyboard = UIStoryboard(name: "Article", bundle: nil)
//        guard let newPostViewController = storyboard.instantiateViewController(withIdentifier: "NewPostViewController") as? NewPostViewController else { return }
//        navigationItem.titleView = nil
//        newPostViewController.transitioningDelegate = self
//        newPostViewController.modalPresentationStyle = .custom
////        present(newPostViewController, animated: true, completion: nil)
//        navigationController?.pushViewController(newPostViewController, animated: true)
//        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setNewPost()
        getCurrentUser()
        addRefreshControl()
        getData(shouldShowLoadingVC: true)
        configureSearchController()
        setNavBar()
        showNavRightButton(shouldShow: true)
        searchResultLabel.isHidden = true
        self.definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBar()
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "想找的關鍵字",
        attributes: [.foregroundColor: UIColor(red: 187, green: 208, blue: 211, alpha: 1)])
        
    }
}

extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isChangeLayout {
            return UITableView.automaticDimension
        } else {
            return tableView.frame.height / 2.5
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = finalArticles[indexPath.row]
        guard let authorObject = article.authorObject else { return UITableViewCell() }
        if isChangeLayout == false {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleTableViewCell.self), for: indexPath) as? ArticleTableViewCell else { return UITableViewCell() }
            cell.fillData(authorImgURLString: authorObject.img,
                          titleLabel: article.title,
                          nameTimeLabel: "\(authorObject.name)・\(article.intervalString)",
                          contentLabel: article.content)
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.lk_registerCellWithNib(identifier: "FilterCollectionViewCell", bundle: nil)
            cell.collectionView.tag = indexPath.row
            cell.replyCount.text = "\(article.replyCount)"
            cell.loveCount.text = "\(article.loveCount)"
            cell.typeLabel.text = article.type
            if article.type == "廣告宣傳" {
                cell.typeLabel.backgroundColor = UIColor.assetColor(.advertise)
                cell.backView.layer.borderColor = UIColor.assetColor(.advertise)?.cgColor
                cell.backView.layer.borderWidth = 2
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleListTableViewCell.self), for: indexPath) as? ArticleListTableViewCell else { return UITableViewCell() }
            cell.titleLabel.text = article.title
            cell.nameAndCreateTime.text = "\(authorObject.name)・\(article.intervalString)"
            cell.replyCount.text = "\(article.replyCount)"
            cell.loveCount.text = "\(article.loveCount)"
            cell.typeLabel.text = "[\(article.type)]"
            if article.type == "廣告宣傳" {
                cell.typeLabel.textColor = UIColor.assetColor(.advertise)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Article", bundle: nil)
        guard let readPostViewController = storyboard.instantiateViewController(withIdentifier: "ReadPostViewController") as? ReadPostViewController else { return }
        readPostViewController.article = allArticle[indexPath.row]
        navigationItem.titleView = nil
        navigationController?.pushViewController(readPostViewController, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
}

extension ArticleViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionItem[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
        cell.layer.cornerRadius = CGFloat(floor((collectionView.bounds.width - itemSpace * (columnCount - 1 + 2)) / columnCount)) / 6
        cell.backgroundColor = UIColor.assetColor(.shadowLightGray)
        cell.optionLabel.text = collectionItem[collectionView.tag][indexPath.item]
        cell.optionLabel.font = UIFont(name: "PingFangTC-Medium", size: 10)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(floor((collectionView.bounds.width - itemSpace * (columnCount - 1)) / columnCount))
        let height = width / 3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return itemSpace
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return itemSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension ArticleViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        isSearching = true
        searchBar.searchTextField.textColor = .black
        
        guard let searchText = searchBar.text else { return }
        searchContent(for: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchContent(for: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        
        if isFilter {
            
            finalArticles = filterResults
            
        } else {
            
            finalArticles = allArticle
            
        }
        
        if finalArticles.isEmpty {
            searchResultLabel.isHidden = false
        } else {
            searchResultLabel.isHidden = true
        }
        
        articleTableView.reloadData()
        searchController.searchBar.resignFirstResponder()
    }
}

extension ArticleViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = newPostBtn.center
        transition.circleColor = newPostBtn.backgroundColor!
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = newPostBtn.center
        transition.circleColor = newPostBtn.backgroundColor!
        return transition
    }
}
