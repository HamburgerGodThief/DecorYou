//
//  ResumeViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/1/31.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class ResumeViewController: UIViewController {
    
    @IBOutlet weak var portfolioCollectionView: UICollectionView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    let itemSpace: CGFloat = 3
    let columnCount: CGFloat = 3
    
    func setNavigationBar() {
        navigationItem.title = "業者履歷"
        let btn = UIButton()
        btn.setTitle("Back", for: .normal)
        btn.setImage(UIImage.asset(.Icons_24px_Back02), for: .normal)
        btn.sizeToFit()
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(backToCraftsmen), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    @objc func backToCraftsmen() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        portfolioCollectionView.dataSource = self
        portfolioCollectionView.delegate = self
        portfolioCollectionView.lk_registerCellWithNib(identifier: String(describing: ResumeCollectionViewCell.self), bundle: nil)
    }
    
}

extension ResumeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Craftsmen", bundle: nil)
        guard let portfolioViewController = storyboard.instantiateViewController(withIdentifier: "PortfolioViewController") as? PortfolioViewController else { return }

        navigationController?.pushViewController(portfolioViewController, animated: true)
        
    }
    
    
}
