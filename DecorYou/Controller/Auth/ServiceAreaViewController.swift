//
//  ServiceAreaViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/14.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

protocol ServiceAreaViewControllerDelegate: AnyObject {
    
    func passDataToParentVC(_ serviceAreaViewController: ServiceAreaViewController)
    
}

class ServiceAreaViewController: UIViewController {

    @IBOutlet weak var serviceAreaCollectionView: UICollectionView!
    @IBOutlet weak var titleView: UIView!
    weak var delegate: ServiceAreaViewControllerDelegate?
    var finalSelectCell: [ServiceAreaCollectionViewCell] = []
    
    let areaData = ["臺北市", "新北市", "基隆市", "桃園市", "新竹縣",
                    "新竹市", "苗栗縣", "臺中市", "南投縣", "彰化縣",
                    "雲林縣", "嘉義縣", "嘉義市", "臺南市", "高雄市",
                    "屏東縣", "宜蘭縣", "花蓮縣", "臺東縣", "澎湖縣",
                    "金門縣", "連江縣"]
    
    func setCollectionView() {
        serviceAreaCollectionView.lk_registerCellWithNib(identifier: String(describing: ServiceAreaCollectionViewCell.self), bundle: nil)
        serviceAreaCollectionView.delegate = self
        serviceAreaCollectionView.dataSource = self
        serviceAreaCollectionView.bounces = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        titleView.layer.cornerRadius = 40
        // Do any additional setup after loading the view.
    }
    
}

extension ServiceAreaViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return areaData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ServiceAreaCollectionViewCell.self), for: indexPath) as? ServiceAreaCollectionViewCell else { return UICollectionViewCell() }
        cell.areaLabel.text = areaData[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 100
        let height = 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let left = CGFloat(32)
        let right = CGFloat(32)
        let top = CGFloat(16)
        let bottom = CGFloat(16)
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ServiceAreaCollectionViewCell else { return }
        if finalSelectCell.contains(cell) {
            cell.areaLabel.backgroundColor = .clear
            cell.select = false
            guard let index = finalSelectCell.firstIndex(of: cell) else { return }
            finalSelectCell.remove(at: index)
            self.delegate?.passDataToParentVC(self)
        } else {
            finalSelectCell.append(cell)
            cell.areaLabel.backgroundColor = .lightGray
            cell.select = true
            self.delegate?.passDataToParentVC(self)
            if finalSelectCell.count > 3 {
                finalSelectCell.first?.areaLabel.backgroundColor = .clear
                finalSelectCell.first?.select = false
                finalSelectCell.removeFirst()
                self.delegate?.passDataToParentVC(self)
            }
        }
    }
    
}
