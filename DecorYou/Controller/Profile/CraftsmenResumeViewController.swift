//
//  CraftsmenResumeViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/5.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class CraftsmenResumeViewController: UIViewController {
    
    @IBOutlet weak var portfolioCollectionView: UICollectionView!
    let itemSpace: CGFloat = 3
    let columnCount: CGFloat = 3
    
    func setCollectionView() {
        portfolioCollectionView.dataSource = self
        portfolioCollectionView.delegate = self
        portfolioCollectionView.lk_registerCellWithNib(identifier: String(describing: ResumeCollectionViewCell.self), bundle: nil)
    }
    
    func setNavigationBar() {
        navigationItem.title = "編輯作品"
        let btn = UIButton()
        btn.setTitle("Back", for: .normal)
        btn.setImage(UIImage.asset(.Icons_24px_Back02), for: .normal)
        btn.sizeToFit()
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(backToProfile), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    @objc func backToProfile() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setCollectionView()
    }
}

extension CraftsmenResumeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 22
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ResumeCollectionViewCell.self), for: indexPath) as? ResumeCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(floor((portfolioCollectionView.bounds.width - itemSpace * (columnCount-1)) / columnCount))
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return itemSpace
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return itemSpace
    }
    
}
