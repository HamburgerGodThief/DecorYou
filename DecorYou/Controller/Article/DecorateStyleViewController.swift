//
//  DecorateStyleViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/7.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

protocol DecorateStyleViewControllerDelegate: AnyObject {
    func addDataToParentVC(_ decorateStyleViewController: DecorateStyleViewController)
    
    func removeDataToParentVC(_ decorateStyleViewController: DecorateStyleViewController)
}

class DecorateStyleViewController: UIViewController {
    
    @IBOutlet weak var decorateStyleCollectionView: UICollectionView!
    
    weak var delegate: DecorateStyleViewControllerDelegate?
    let decorateStyleArray = ["工業", "後現代", "日系",
                              "黑白色調", "森林", "清新",
                              "輕工業", "木質調", "奢華",
                              "北歐", "古典", "鄉村",
                              "地中海", "美式", "東方", "無特定"]
    var selectCell = [DecorateStyleCollectionViewCell]()
    var selectStyle = [String]()
    let itemSpace: CGFloat = 2
    let columnCount: CGFloat = 2
    
    func setCollectionView() {
        decorateStyleCollectionView.delegate = self
        decorateStyleCollectionView.dataSource = self
        decorateStyleCollectionView.lk_registerCellWithNib(identifier: String(describing: DecorateStyleCollectionViewCell.self), bundle: nil)
        decorateStyleCollectionView.layer.cornerRadius = 30
        decorateStyleCollectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        decorateStyleCollectionView.bounces = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
    }
}

extension DecorateStyleViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {

            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: String(describing: DecorateStyleCollectionReusableView.self),
                for: indexPath
            )

            guard let decorateStyleView = header as? DecorateStyleCollectionReusableView else { return header }

            decorateStyleView.titleLabel.text = "至多選擇兩項"

            return decorateStyleView
        }

        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return decorateStyleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DecorateStyleCollectionViewCell.self), for: indexPath) as? DecorateStyleCollectionViewCell else { return UICollectionViewCell() }
        cell.decorateStyleLabel.text = decorateStyleArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(decorateStyleCollectionView.bounds.width  / columnCount)
        let height = CGFloat(60)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DecorateStyleCollectionViewCell else { return }
        guard let styleString = cell.decorateStyleLabel.text else { return }
        if selectCell.contains(cell) {
            cell.contentView.backgroundColor = .white
            cell.select = false
            guard let index = selectCell.firstIndex(of: cell) else { return }
            selectCell.remove(at: index)
            selectStyle.remove(at: index)
            self.delegate?.removeDataToParentVC(self)
        } else {
            selectCell.append(cell)
            selectStyle.append(styleString)
            cell.contentView.backgroundColor = UIColor.assetColor(.mainColor)
            cell.select = true
            self.delegate?.addDataToParentVC(self)
            if selectCell.count > 2 {
                selectCell.first?.contentView.backgroundColor = .white
                selectCell.first?.select = false
                selectCell.removeFirst()
                selectStyle.removeFirst()
                self.delegate?.removeDataToParentVC(self)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DecorateStyleCollectionViewCell else { return }
        cell.contentView.backgroundColor = UIColor.assetColor(.highlightColor)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DecorateStyleCollectionViewCell else { return }
        cell.contentView.backgroundColor = nil
    }
    
}
