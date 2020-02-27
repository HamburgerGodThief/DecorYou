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
    var filterCraftsmen: [User] = []
    var finalData: [User] = []
    var isFilter: Bool = false
    let itemSpace: CGFloat = 16
    let columnCount: CGFloat = 2
    
    func getAllCraftsmen() {
        presentLoadingVC()
        UserManager.shared.fetchAllCraftsmen(completion: { [weak self] result in
            switch result {
            case .success(let allCraftsmen):
                guard let strongSelf = self else { return }
                strongSelf.dismiss(animated: true, completion: nil)
                strongSelf.allCraftsmen = allCraftsmen
                strongSelf.finalData = strongSelf.allCraftsmen
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
        showNavRightButton(shouldShow: true)
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
            let filterBtn = UIBarButtonItem(image: UIImage.asset(.Icons_24px_FilterSelected), style: .plain, target: self, action: #selector(setfilter))
            return filterBtn
        } else {
            let filterBtn = UIBarButtonItem(image: UIImage.asset(.Icons_24px_Filter), style: .plain, target: self, action: #selector(setfilter))
            return filterBtn
        }
    }
    
    func searching(shouldShow: Bool) {
        showNavRightButton(shouldShow: !shouldShow)
        searchController.searchBar.showsCancelButton = shouldShow
    }
    
    func searchContent(for searchText: String) {
//        searchResultLabel.isHidden = true
        if isFilter {
            finalData = filterCraftsmen.filter({ (craftsman) -> Bool in
                let name = craftsman.name
                let isMatch = name.localizedCaseInsensitiveContains(searchText)
                return isMatch
            })
        } else {
            finalData = allCraftsmen.filter({ (craftsman) -> Bool in
                let name = craftsman.name
                let isMatch = name.localizedCaseInsensitiveContains(searchText)
                return isMatch
            })
        }
        
        if filterCraftsmen.isEmpty {
//            searchResultLabel.isHidden = false
        }
        craftsmenCollectionView.reloadData()
    }
    
    @objc func setfilter() {
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
        let location = finalData[indexPath.item].serviceLocation.reduce("", { (sum, string) -> String in
            return sum + string + "、"
        })
        cell.logoImg.loadImage(finalData[indexPath.item].img, placeHolder: UIImage(systemName: "person.crop.circle"))
        cell.logoImg.tintColor = .lightGray
        cell.nameLabel.text = finalData[indexPath.item].name
        cell.serviceLabel.text = finalData[indexPath.item].serviceCategory!
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
        resumeViewController.craftsman = finalData[indexPath.item]
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
        searching(shouldShow: true)
        guard let searchText = searchBar.text else { return }
        searchContent(for: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        searchContent(for: searchText)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        print("End editing")
//        guard let searchText = searchBar.text else { return }
//        searchContent(for: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Clicked Cancel Btn")
        searchBar.searchTextField.backgroundColor = UIColor.assetColor(.darkMainColor)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "想找哪位匠人",
                                                                             attributes: [.foregroundColor: UIColor(red: 187, green: 208, blue: 211, alpha: 1)])
        finalData = allCraftsmen
        craftsmenCollectionView.reloadData()
        searching(shouldShow: false)
        searchController.searchBar.resignFirstResponder()
    }
}
