//
//  FilterViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/21.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var setBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var contentViewLeading: NSLayoutConstraint!
    var conditionsArray: [ConditionProtocol] = [StyleCondition(conditionValue: ""),
                                                LocationCondition(conditionValue: ""),
                                                SizeMinCondition(conditionValue: 0),
                                                SizeMaxCondition(conditionValue: 0),
                                                ReplyMinCondition(conditionValue: 0),
                                                ReplyMaxCondition(conditionValue: 0),
                                                LoveMinCondition(conditionValue: 0),
                                                LoveMaxCondition(conditionValue: 0)]
//    var locationCondition: LocationCondition = LocationCondition(conditionValue: "")
//    var sizeMinCondition: SizeMinCondition = SizeMinCondition(conditionValue: 0)
//    var sizeMaxCondition: SizeMaxCondition = SizeMaxCondition(conditionValue: 9999)
//    var replyMinCondition: ReplyMinCondition = ReplyMinCondition(conditionValue: 0)
//    var replyMaxCondition: ReplyMaxCondition = ReplyMaxCondition(conditionValue: 9999)
//    var loveMinCondition: LoveMinCondition = LoveMinCondition(conditionValue: 0)
//    var loveMaxCondition: LoveMaxCondition = LoveMaxCondition(conditionValue: 9999)
    var decorateStyleCell: FilterCollectionTableViewCell?
    
    let sectionHeaderTitle: [String] = ["裝潢風格", "房屋地區", "房屋坪數", "回覆文章數量", "被收藏次數"]
    let decorateStyleArray = ["工業", "後現代", "日系",
                              "黑白色調", "森林", "清新",
                              "輕工業", "木質調", "奢華",
                              "北歐", "古典", "鄉村",
                              "地中海", "美式", "東方", "無特定"]
    let areaData = ["臺北市", "新北市", "基隆市", "桃園市", "新竹縣",
                     "新竹市", "苗栗縣", "臺中市", "南投縣", "彰化縣",
                     "雲林縣", "嘉義縣", "嘉義市", "臺南市", "高雄市",
                     "屏東縣", "宜蘭縣", "花蓮縣", "臺東縣", "澎湖縣",
                     "金門縣", "連江縣"]
    var firstSelected: String = ""
    
    func viewAddTapGesture() {
        let singleFinger = UITapGestureRecognizer(target: self, action: #selector(singleTap))

        singleFinger.numberOfTapsRequired = 1

        singleFinger.numberOfTouchesRequired = 1
    
        dismissView.addGestureRecognizer(singleFinger)
    }
    
    @IBAction func didTouchSet(_ sender: Any) {
        guard let tabVC = self.presentingViewController as? STTabBarViewController else { return }
        guard let navVC = tabVC.selectedViewController as? UINavigationController else { return }
        guard let articleVC = navVC.topViewController as? ArticleViewController else { return }
        var filterArticles = articleVC.allArticle
        
        for condition in conditionsArray {
            filterArticles = condition.filter(data: filterArticles)
        }
        
        if articleVC.finalArticles.count == filterArticles.count {
            articleVC.isFilter = false
        } else {
            articleVC.isFilter = true
        }
        
        articleVC.filterResults = filterArticles
        articleVC.finalArticles = filterArticles
        
        if articleVC.finalArticles.isEmpty {
            articleVC.searchResultLabel.isHidden = false
        }
        
        articleVC.combineDataForCollectionItem()
        articleVC.showNavRightButton(shouldShow: true)
        articleVC.articleTableView.reloadData()
        
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func didTouchReset(_ sender: Any) {
        guard let tabVC = self.presentingViewController as? STTabBarViewController else { return }
        guard let navVC = tabVC.selectedViewController as? UINavigationController else { return }
        guard let articleVC = navVC.topViewController as? ArticleViewController else { return }
    
        articleVC.isFilter = false
        articleVC.showNavRightButton(shouldShow: true)
        articleVC.finalArticles = articleVC.allArticle
        conditionsArray = [StyleCondition(conditionValue: ""),
                           LocationCondition(conditionValue: ""),
                           SizeMinCondition(conditionValue: 0),
                           SizeMaxCondition(conditionValue: 9999),
                           ReplyMinCondition(conditionValue: 0),
                           ReplyMaxCondition(conditionValue: 9999),
                           LoveMinCondition(conditionValue: 0),
                           LoveMaxCondition(conditionValue: 9999)]
        firstSelected = ""
        articleVC.combineDataForCollectionItem()
        tableView.reloadData()
        decorateStyleCell?.collectionView.reloadData()
        articleVC.searchResultLabel.isHidden = true
        articleVC.articleTableView.reloadData()
    }
    
    @objc func singleTap() {
        
        dismiss(animated: false, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAddTapGesture()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.lk_registerCellWithNib(identifier: "FilterCollectionTableViewCell", bundle: nil)
        tableView.lk_registerCellWithNib(identifier: "FilterPickerTableViewCell", bundle: nil)
        tableView.lk_registerCellWithNib(identifier: "FilterTableViewCell", bundle: nil)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.bounces = false
        resetBtn.layer.borderColor = UIColor.assetColor(.mainColor)?.cgColor
        resetBtn.layer.borderWidth = 1
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = UINib(nibName: "FilterTableViewHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? FilterTableViewHeaderView else { return nil }
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
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCollectionTableViewCell", for: indexPath) as? FilterCollectionTableViewCell else { return UITableViewCell() }
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.lk_registerCellWithNib(identifier: "FilterCollectionViewCell", bundle: nil)
            decorateStyleCell = cell
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterPickerTableViewCell", for: indexPath) as? FilterPickerTableViewCell else { return UITableViewCell() }
            cell.locationTextField.delegate = conditionsArray[1]
            cell.locationTextField.inputView = cell.pickerView
            cell.locationTextField.text = firstSelected
            cell.pickerView.delegate = self
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell", for: indexPath) as? FilterTableViewCell else { return UITableViewCell() }
            if indexPath.section == 2 {
                cell.minValueTextField.delegate = conditionsArray[2]
                cell.maxValueTextField.delegate = conditionsArray[3]
            } else if indexPath.section == 3 {
                cell.minValueTextField.delegate = conditionsArray[4]
                cell.maxValueTextField.delegate = conditionsArray[5]
            } else {
                cell.minValueTextField.delegate = conditionsArray[6]
                cell.maxValueTextField.delegate = conditionsArray[7]
            }
            cell.minValueTextField.placeholder = "最小值"
            cell.maxValueTextField.placeholder = "最大值"
            cell.minValueTextField.text = ""
            cell.maxValueTextField.text = ""
            return cell
        }
    }
}

extension FilterViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return decorateStyleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FilterCollectionViewCell.self), for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
        cell.optionLabel.text = decorateStyleArray[indexPath.item]
        cell.backgroundColor = UIColor.assetColor(.shadowLightGray)
        cell.layer.borderWidth = 0
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell else { return }
        cell.backgroundColor = .white
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.assetColor(.mainColor)?.cgColor
        guard let styleText = cell.optionLabel.text else { return }
        conditionsArray[0] = StyleCondition(conditionValue: styleText)
        
//        let style = StyleCondition(conditionValue: styleText)
//        conditionsArray =  conditionsArray.filter { element in
//
//            if element as? StyleCondition == nil {
//                return true
//            }
//            return false
//        }
//        conditionsArray.append(style)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell else { return }
        cell.backgroundColor = UIColor.assetColor(.shadowLightGray)
        cell.layer.borderWidth = 0
    }
}

extension FilterViewController: UITextFieldDelegate {
    /*
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cell = textField.superview?.superview?.superview as? FilterTableViewCell else { return }
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if indexPath.section == 1 {
            guard let location = textField.text else { return }
            let locationCondition = LocationCondition(conditionValue: location)
            conditionsArray =  conditionsArray.filter { element in
                
                if element as? LocationCondition == nil {
                    return true
                }
                return false
            }
            conditionsArray.append(locationCondition)
        } else if indexPath.section == 2 {
            if textField == cell.minValueTextField {
                guard let minSize = Int(textField.text!) else { return }
                let sizeMin = SizeMinCondition(conditionValue: minSize)
                conditionsArray =  conditionsArray.filter { element in
                    
                    if element as? SizeMinCondition == nil {
                        return true
                    }
                    return false
                }
                conditionsArray.append(sizeMin)
            } else {
                guard let maxSize = Int(textField.text!) else { return }
                let sizeMax = SizeMaxCondition(conditionValue: maxSize)
                conditionsArray =  conditionsArray.filter { element in
                    
                    if element as? SizeMaxCondition == nil {
                        return true
                    }
                    return false
                }
                conditionsArray.append(sizeMax)
            }
        } else if indexPath.section == 3 {
            if textField == cell.minValueTextField {
                guard let minReply = Int(textField.text!) else { return }
                let replyMin = ReplyMinCondition(conditionValue: minReply)
                conditionsArray =  conditionsArray.filter { element in
                    
                    if element as? ReplyMinCondition == nil {
                        return true
                    }
                    return false
                }
                conditionsArray.append(replyMin)
            } else {
                guard let maxReply = Int(textField.text!) else { return }
                let replyMax = ReplyMaxCondition(conditionValue: maxReply)
                conditionsArray =  conditionsArray.filter { element in
                    
                    if element as? ReplyMaxCondition == nil {
                        return true
                    }
                    return false
                }
                conditionsArray.append(replyMax)
            }
        } else {
            if textField == cell.minValueTextField {
                guard let minLove = Int(textField.text!) else { return }
                let loveMin = LoveMinCondition(conditionValue: minLove)
                conditionsArray =  conditionsArray.filter { element in
                    
                    if element as? LoveMinCondition == nil {
                        return true
                    }
                    return false
                }
                conditionsArray.append(loveMin)
            } else {
                guard let maxLove = Int(textField.text!) else { return }
                let loveMax = LoveMaxCondition(conditionValue: maxLove)
                conditionsArray =  conditionsArray.filter { element in
                    
                    if element as? LoveMaxCondition == nil {
                        return true
                    }
                    return false
                }
                conditionsArray.append(loveMax)
            }
        }
    }
 */
}

extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return areaData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        firstSelected = areaData[row]
        let locationString = firstSelected
        let location = LocationCondition(conditionValue: locationString)
        conditionsArray =  conditionsArray.filter { element in
            
            if element as? LocationCondition == nil {
                return true
            }
            return false
        }
        conditionsArray.append(location)
        tableView.reloadData()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return areaData[row]
        
    }
}
