//
//  AreaViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/26.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class AreaViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.delegate = self
            
            collectionView.dataSource = self
            
            collectionView.lk_registerCellWithNib(identifier: "ServiceAreaCollectionViewCell", bundle: nil)
                        
        }
        
    }
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    let itemSpace: CGFloat = 16
    let columnCount: CGFloat = 3
    let areaData = ["臺北市", "新北市", "基隆市", "桃園市", "新竹縣",
                    "新竹市", "苗栗縣", "臺中市", "南投縣", "彰化縣",
                    "雲林縣", "嘉義縣", "嘉義市", "臺南市", "高雄市",
                    "屏東縣", "宜蘭縣", "花蓮縣", "臺東縣", "澎湖縣",
                    "金門縣", "連江縣"]
    
    
    @IBAction func touchConfirm(_ sender: Any) {
    }
    
    @IBAction func touchBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension AreaViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        let width = (collectionView.frame.width - itemSpace * 4) / columnCount
        let height = CGFloat(40)
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
    
}
