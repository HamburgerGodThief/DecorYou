//
//  PortfolioTableViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/3.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class ProfolioTableViewCell: UITableViewCell {
    
    @IBOutlet weak var portfolioCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        portfolioCollectionView.lk_registerCellWithNib(identifier: String(describing: ProfolioCollectionViewCell.self), bundle: nil)
        portfolioCollectionView.delegate = self
        portfolioCollectionView.dataSource = self
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension ProfolioTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProfolioCollectionViewCell.self), for: indexPath) as? ProfolioCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(150)
        let height = CGFloat(self.bounds.height)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return 0
    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let item = collectionView.cellForItem(at: indexPath) as? PortfolioCollectionViewCell else { return}
//        let apple = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations:)
//
//        apple.startAnimation()
//    }
}
