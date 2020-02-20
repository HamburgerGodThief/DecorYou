//
//  FilterView.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/20.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class FilterView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var confirmFilterBtn: UIButton!
    let sectionHeaderTitle: [String] = ["裝潢風格", "房屋地區", "房屋坪數", "回覆文章數量", "被收藏次數"]
    let decorateStyleArray = ["工業", "後現代", "日系",
                              "黑白色調", "森林", "清新",
                              "輕工業", "木質調", "奢華",
                              "北歐", "古典", "鄉村",
                              "地中海", "美式", "東方", "無特定"]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.lk_registerCellWithNib(identifier: "FilterCollectionTableViewCell", bundle: nil)
        tableView.lk_registerCellWithNib(identifier: "FilterTableViewCell", bundle: nil)
    }
    
    
}

extension FilterView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UINib(nibName: "FilterTableViewHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! FilterTableViewHeaderView
        headerView.sectionTitleLabel.text = sectionHeaderTitle[section]
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCollectionTableViewCell", for: indexPath) as? FilterCollectionTableViewCell else { return UITableViewCell() }
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.lk_registerCellWithNib(identifier: "FilterCollectionViewCell", bundle: nil)
            return cell
        case 1:
            print("ttt")
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell", for: indexPath) as? FilterTableViewCell else { return UITableViewCell() }
            
            return cell
        }
        return UITableViewCell()
    }
}

extension FilterView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return decorateStyleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FilterCollectionViewCell.self), for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
        cell.optionLabel.text = decorateStyleArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(collectionView.bounds.width - 10) / 2
        let height = CGFloat(30)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return 10
    }
}
