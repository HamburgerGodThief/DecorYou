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
    
    func searchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "想找哪位業者呢..."
        navigationItem.titleView = searchBar
    
        let filterBtn = UIBarButtonItem(image: UIImage.asset(.Icons_24px_Filter), style: .plain, target: self, action: #selector(setfilter))
        navigationItem.rightBarButtonItem = filterBtn
        navigationController?.navigationBar.backgroundColor = UIColor.assetColor(.mainColor)
    }
    
    @objc func setfilter() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar()
        craftsmenCollectionView.lk_registerCellWithNib(identifier: String(describing: CraftsmenCollectionViewCell.self), bundle: nil)
        craftsmenCollectionView.delegate = self
        craftsmenCollectionView.dataSource = self
    }
}

extension CraftsmenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CraftsmenCollectionViewCell.self), for: indexPath) as? CraftsmenCollectionViewCell else { return UICollectionViewCell() }
        cell.layoutIfNeeded()
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
