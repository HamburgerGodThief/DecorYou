//
//  CraftsmenFilterViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/23.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class CraftsmenFilterViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var setBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dismissView: UIView!
    var conditionsArray: [CraftsmenConditionProtocol] = []
    var firstConditionCell: [FilterCollectionViewCell] = []
    var secondConditionCell: [FilterCollectionViewCell] = []
    let itemSpace: CGFloat = 18
    let columnCount: CGFloat = 3
    let serviceCategoryData: [String] = ["室內設計師", "木工師傅", "水電師傅",
                                         "油漆師傅", "弱電師傅", "園藝設計師", "其他"]
    let areaData = ["臺北市", "新北市", "基隆市", "桃園市", "新竹縣",
                    "新竹市", "苗栗縣", "臺中市", "南投縣", "彰化縣",
                    "雲林縣", "嘉義縣", "嘉義市", "臺南市", "高雄市",
                    "屏東縣", "宜蘭縣", "花蓮縣", "臺東縣", "澎湖縣",
                    "金門縣", "連江縣"]
    
    @IBAction func didTouchSet(_ sender: Any) {
        guard let tabVC = self.presentingViewController as? STTabBarViewController else { return }
        guard let navVC = tabVC.selectedViewController as? UINavigationController else { return }
        guard let craftsmenVC = navVC.topViewController as? CraftsmenViewController else { return }
        var fitlerCraftsmen = craftsmenVC.allCraftsmen
        
        for condition in conditionsArray {
            fitlerCraftsmen = condition.filter(data: fitlerCraftsmen)
        }
        
        craftsmenVC.filterResult = fitlerCraftsmen
        craftsmenVC.finalResult = craftsmenVC.filterResult
        if conditionsArray.isEmpty {
            craftsmenVC.isFilter = false
        } else {
            craftsmenVC.isFilter = true
        }
        if craftsmenVC.finalResult.isEmpty {
            craftsmenVC.searchResultLabel.isHidden = false
        }
        craftsmenVC.showNavRightButton(shouldShow: true)
        craftsmenVC.craftsmenCollectionView.reloadData()
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func didTouchReset(_ sender: Any) {
        guard let tabVC = self.presentingViewController as? STTabBarViewController else { return }
        guard let navVC = tabVC.selectedViewController as? UINavigationController else { return }
        guard let craftsmenVC = navVC.topViewController as? CraftsmenViewController else { return }
        craftsmenVC.finalResult = craftsmenVC.allCraftsmen
        
        conditionsArray = []
        firstConditionCell = []
        secondConditionCell = []
        collectionView.reloadData()
        craftsmenVC.searchResultLabel.isHidden = true
        craftsmenVC.craftsmenCollectionView.reloadData()
    }
    
    func viewAddTapGesture() {
        let singleFinger = UITapGestureRecognizer(target: self, action: #selector(singleTap))

        singleFinger.numberOfTapsRequired = 1

        singleFinger.numberOfTouchesRequired = 1
    
        dismissView.addGestureRecognizer(singleFinger)
    }
    
    @objc func singleTap() {
        dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAddTapGesture()
        resetBtn.layer.borderColor = UIColor.assetColor(.mainColor)?.cgColor
        resetBtn.layer.borderWidth = 1
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.lk_registerCellWithNib(identifier: "FilterCollectionViewCell", bundle: nil)
    }
}

extension CraftsmenFilterViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: CraftsmenFilterCollectionReusableView.self),
            for: indexPath
        )

        guard let headerView = header as? CraftsmenFilterCollectionReusableView else { return header }
        
        if indexPath.section == 0 {
            headerView.sectionTitleLabel.text = "服務項目"
        } else {
            headerView.sectionTitleLabel.text = "服務地區"
        }

        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return serviceCategoryData.count
        } else {
            return areaData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
        cell.layer.cornerRadius = CGFloat(floor((collectionView.bounds.width - itemSpace * (columnCount - 1 + 2)) / columnCount)) / 6
        cell.select = false
        
        if indexPath.section == 0 {
            cell.optionLabel.text = serviceCategoryData[indexPath.item]
            return cell
        } else {
            cell.optionLabel.text = areaData[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(floor((collectionView.bounds.width - itemSpace * (columnCount - 1 + 2)) / columnCount))
        let height = width / 3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return itemSpace
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return itemSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: itemSpace, bottom: 10, right: itemSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell else { return }
        cell.select = !cell.select
        if indexPath.section == 0 {
            conditionsArray =  conditionsArray.filter { element in
                if element as? ServiceCategoryCondition == nil {
                    return true
                }
                return false
            }
            if firstConditionCell.contains(cell) {
                firstConditionCell.removeFirst()
            } else {
                firstConditionCell.append(cell)
                guard let catText = cell.optionLabel.text else { return }
                let catetory = ServiceCategoryCondition(conditionValue: catText)
                conditionsArray.append(catetory)
            }
            if firstConditionCell.count > 1 {
                firstConditionCell[0].select = !firstConditionCell[0].select
                firstConditionCell.removeFirst()
            }
        } else {
            conditionsArray =  conditionsArray.filter { element in
                if element as? ServiceLocationCondition == nil {
                    return true
                }
                return false
            }
            if secondConditionCell.contains(cell) {
                
                let index = secondConditionCell.firstIndex(of: cell)
                
                secondConditionCell.remove(at: index!)
                
            } else {
                
                secondConditionCell.append(cell)
                guard let locationText = cell.optionLabel.text else { return }
                let location = ServiceLocationCondition(conditionValue: locationText)
                conditionsArray.append(location)
                
            }
            
            if secondConditionCell.count > 1 {
                
                secondConditionCell[0].select = !secondConditionCell[0].select
                
                secondConditionCell.removeFirst()
            }
        }
    }
}
