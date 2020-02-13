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
    var searchController = UISearchController(searchResultsController: nil)
    
    var allCraftsmen: [User] = []
    var searchCraftsmen: [User] = []
    var finalData: [User] = []
    
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
            let filterBtn = UIBarButtonItem(image: UIImage.asset(.Icons_24px_Filter), style: .plain, target: self, action: #selector(setfilter))
            navigationItem.rightBarButtonItem = filterBtn
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func getAllCraftsmen() {
        UserManager.shared.fetchAllCraftsmen(completion: { [weak self] result in
            switch result {
            case .success(let allCraftsmen):
                guard let strongSelf = self else { return }
                strongSelf.allCraftsmen = allCraftsmen
                strongSelf.isSearch(isSearch: false)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func isSearch(isSearch: Bool) {
        finalData = isSearch ? searchCraftsmen: allCraftsmen
        craftsmenCollectionView.reloadData()
    }
    
    func searchContent(for searchText: String) {
        
        searchCraftsmen = allCraftsmen.filter({ (craftsman) -> Bool in
            let name = craftsman.name
            let isMatch = name.localizedCaseInsensitiveContains(searchText)
            return isMatch
        })
        
        finalData = searchCraftsmen
        
        craftsmenCollectionView.reloadData()
        
    }
    
    @objc func setfilter() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        craftsmenCollectionView.lk_registerCellWithNib(identifier: String(describing: CraftsmenCollectionViewCell.self), bundle: nil)
        craftsmenCollectionView.delegate = self
        craftsmenCollectionView.dataSource = self
        getAllCraftsmen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSearchController()
        setNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "想找哪位匠人",
        attributes: [.foregroundColor: UIColor(red: 187, green: 208, blue: 211, alpha: 1)])
    }
}

extension CraftsmenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return finalData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CraftsmenCollectionViewCell.self), for: indexPath) as? CraftsmenCollectionViewCell else { return UICollectionViewCell() }
        cell.layoutIfNeeded()
        cell.logoImg.loadImage(finalData[indexPath.item].img)
        cell.nameLabel.text = "名稱: \(finalData[indexPath.item].name)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 180
        let height = 300
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let left = CGFloat(16)
        let right = CGFloat(16)
        let top = CGFloat(16)
        let bottom = CGFloat(16)
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Craftsmen", bundle: nil)
        guard let resumeViewController = storyboard.instantiateViewController(withIdentifier: "ResumeViewController") as? ResumeViewController else { return }

        navigationController?.pushViewController(resumeViewController, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
}

extension CraftsmenViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Start editing")
        searchBar.searchTextField.backgroundColor = UIColor.white
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "想找哪位匠人", attributes: [.foregroundColor: UIColor.lightGray])
//        searching(shouldShow: true)
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
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "想找哪位匠人",
                                                                             attributes: [.foregroundColor: UIColor(red: 187, green: 208, blue: 211, alpha: 1)])
//        searching(shouldShow: false)
        searchController.searchBar.resignFirstResponder()
    }
}
