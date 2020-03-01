//
//  CraftsmenViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/1/22.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import Foundation
import UIKit

class CraftsmenViewController: UIViewController {
    
    @IBOutlet weak var craftsmenCollectionView: UICollectionView!
    @IBOutlet weak var searchResultLabel: UILabel!
    var searchController = UISearchController(searchResultsController: nil)
    
    var allCraftsmen: [User] = []
    var filterResult: [User] = []
    var finalResult: [User] = []
    var isFilter: Bool = false
    var isSearching: Bool = false {
        
        didSet {
            
            searching(shouldShow: isSearching)
            
        }
        
    }
    let itemSpace: CGFloat = 16
    let columnCount: CGFloat = 2
    
    func getAllCraftsmen() {
        let loadingVC = presentLoadingVC()
        UserManager.shared.fetchAllCraftsmen(completion: { [weak self] result in
            switch result {
            case .success(let allCraftsmen):
                guard let strongSelf = self else { return }
                loadingVC.dismiss(animated: false, completion: nil)
                strongSelf.allCraftsmen = allCraftsmen
                strongSelf.finalResult = strongSelf.allCraftsmen
                strongSelf.craftsmenCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        })
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
    }
    
    func showNavRightButton(shouldShow: Bool) {
        if shouldShow {
            let filterBtn = isFiltering(isFilter: isFilter)
            navigationItem.rightBarButtonItem = filterBtn
        } else {
            navigationItem.rightBarButtonItem = nil
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
    
    func searching(shouldShow: Bool) {
        
        showNavRightButton(shouldShow: !shouldShow)
        
        searchController.searchBar.showsCancelButton = shouldShow
        
        searchController.searchBar.searchTextField.backgroundColor = shouldShow ? .white : UIColor.assetColor(.darkMainColor)
        
        searchController.searchBar.searchTextField.attributedPlaceholder = shouldShow ?
            NSAttributedString(string: "想找哪位匠人", attributes: [.foregroundColor: UIColor.lightGray]) :
            NSAttributedString(string: "想找哪位匠人", attributes: [.foregroundColor: UIColor(red: 187, green: 208, blue: 211, alpha: 1)])
    }
    
    func searchContent(for searchText: String) {

        if isFilter {
            
            finalResult = filterResult.filter({ (craftsman) -> Bool in
                let name = craftsman.name
                let isMatch = name.localizedCaseInsensitiveContains(searchText)
                return isMatch
            })
            
        } else {
            
            finalResult = allCraftsmen.filter({ (craftsman) -> Bool in
                let name = craftsman.name
                let isMatch = name.localizedCaseInsensitiveContains(searchText)
                return isMatch
            })
            
        }
        
        if finalResult.isEmpty {
            searchResultLabel.isHidden = false
        } else {
            searchResultLabel.isHidden = true
        }
        
        craftsmenCollectionView.reloadData()
    }
    
    @objc func configureSlideInFilter() {
        searchResultLabel.isHidden = true
        guard let tabBarController = tabBarController as? STTabBarViewController else { return }
        present(tabBarController.craftsmenFilterVC , animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultLabel.isHidden = true
        craftsmenCollectionView.lk_registerCellWithNib(identifier: String(describing: CraftsmenCollectionViewCell.self), bundle: nil)
        craftsmenCollectionView.delegate = self
        craftsmenCollectionView.dataSource = self
        getAllCraftsmen()
        configureSearchController()
        setNavBar()
        showNavRightButton(shouldShow: true)
        self.definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBar()
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "想找哪位匠人",
        attributes: [.foregroundColor: UIColor(red: 187, green: 208, blue: 211, alpha: 1)])
    }
}

extension CraftsmenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return finalResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CraftsmenCollectionViewCell.self), for: indexPath) as? CraftsmenCollectionViewCell else { return UICollectionViewCell() }
        cell.layoutIfNeeded()
        let location = finalResult[indexPath.item].serviceLocation.joined(separator: "、")
        cell.logoImg.loadImage(finalResult[indexPath.item].img, placeHolder: UIImage(systemName: "person.crop.circle"))
        cell.logoImg.tintColor = .lightGray
        cell.nameLabel.text = finalResult[indexPath.item].name
        cell.serviceLabel.text = finalResult[indexPath.item].serviceCategory!
        cell.locationLabel.text = location
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat((collectionView.frame.width - itemSpace * 3) / 2)
        let height = CGFloat(270)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let left = itemSpace
        let right = itemSpace
        let top = itemSpace
        let bottom = itemSpace
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return itemSpace
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return itemSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Craftsmen", bundle: nil)
        guard let resumeViewController = storyboard.instantiateViewController(withIdentifier: "ResumeViewController") as? ResumeViewController else { return }
        navigationItem.titleView = nil
        resumeViewController.craftsman = finalResult[indexPath.item]
        navigationController?.pushViewController(resumeViewController, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
}

extension CraftsmenViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Start editing")
        searchResultLabel.isHidden = true
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
            
            finalResult = filterResult
            
        } else {
            
            finalResult = allCraftsmen
            
        }
        
        if finalResult.isEmpty {
            searchResultLabel.isHidden = false
        } else {
            searchResultLabel.isHidden = true
        }
        
        craftsmenCollectionView.reloadData()
        searchController.searchBar.resignFirstResponder()
    }
}
