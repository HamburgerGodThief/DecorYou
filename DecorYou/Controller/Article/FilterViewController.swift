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
    var conditionsArray: [ConditionDelegate] = []
    let sectionHeaderTitle: [String] = ["裝潢風格", "房屋地區", "房屋坪數", "回覆文章數量", "被收藏次數"]
    let decorateStyleArray = ["工業", "後現代", "日系",
                              "黑白色調", "森林", "清新",
                              "輕工業", "木質調", "奢華",
                              "北歐", "古典", "鄉村",
                              "地中海", "美式", "東方", "無特定"]
    let first_level_area_data = ["臺北市", "新北市", "基隆市", "桃園市", "新竹縣",
                                 "新竹市", "苗栗縣", "臺中市", "南投縣", "彰化縣",
                                 "雲林縣", "嘉義縣", "嘉義市", "臺南市", "高雄市",
                                 "屏東縣", "宜蘭縣", "花蓮縣", "臺東縣", "澎湖縣",
                                 "金門縣", "連江縣"]
    let second_level_area_data = [[
        "中正區", "大同區", "中山區", "萬華區", "信義區", "松山區", "大安區", "南港區", "北投區", "內湖區", "士林區", "文山區"
        ], [
            "板橋區", "新莊區", "泰山區", "林口區", "淡水區", "金山區", "八里區", "萬里區", "石門區", "三芝區", "瑞芳區", "汐止區", "平溪區", "貢寮區", "雙溪區", "深坑區", "石碇區", "新店區", "坪林區", "烏來區", "中和區", "永和區", "土城區", "三峽區", "樹林區", "鶯歌區", "三重區", "蘆洲區", "五股區"
        ], [
            "仁愛區", "中正區", "信義區", "中山區", "安樂區", "暖暖區", "七堵區"
        ], [
            "桃園區", "中壢區", "平鎮區", "八德區", "楊梅區", "蘆竹區", "龜山區", "龍潭區", "大溪區", "大園區", "觀音區", "新屋區", "復興區"
        ], [
            "竹北市", "竹東鎮", "新埔鎮", "關西鎮", "峨眉鄉", "寶山鄉", "北埔鄉", "橫山鄉", "芎林鄉", "湖口鄉", "新豐鄉", "尖石鄉", "五峰鄉"
        ],
                                  [
            "東區", "北區", "香山區"
        ], [
            "苗栗市", "通霄鎮", "苑裡鎮", "竹南鎮", "頭份鎮", "後龍鎮", "卓蘭鎮", "西湖鄉", "頭屋鄉", "公館鄉", "銅鑼鄉", "三義鄉", "造橋鄉", "三灣鄉", "南庄鄉", "大湖鄉", "獅潭鄉", "泰安鄉"
        ], [
            "中區", "東區", "南區", "西區", "北區", "北屯區", "西屯區", "南屯區", "太平區", "大里區", "霧峰區", "烏日區", "豐原區", "后里區", "東勢區", "石岡區", "新社區", "和平區", "神岡區", "潭子區", "大雅區", "大肚區", "龍井區", "沙鹿區", "梧棲區", "清水區", "大甲區", "外埔區", "大安區"
        ], [
            "南投市", "埔里鎮", "草屯鎮", "竹山鎮", "集集鎮", "名間鄉", "鹿谷鄉", "中寮鄉", "魚池鄉", "國姓鄉", "水里鄉", "信義鄉", "仁愛鄉"
        ], [
            "彰化市", "員林鎮", "和美鎮", "鹿港鎮", "溪湖鎮", "二林鎮", "田中鎮", "北斗鎮", "花壇鄉", "芬園鄉", "大村鄉", "永靖鄉", "伸港鄉", "線西鄉", "福興鄉", "秀水鄉", "埔心鄉", "埔鹽鄉", "大城鄉", "芳苑鄉", "竹塘鄉", "社頭鄉", "二水鄉", "田尾鄉", "埤頭鄉", "溪州鄉"
        ],
                                  [
            "斗六市", "斗南鎮", "虎尾鎮", "西螺鎮", "土庫鎮", "北港鎮", "莿桐鄉", "林內鄉", "古坑鄉", "大埤鄉", "崙背鄉", "二崙鄉", "麥寮鄉", "臺西鄉", "東勢鄉", "褒忠鄉", "四湖鄉", "口湖鄉", "水林鄉", "元長鄉"
        ], [
            "太保市", "朴子市", "布袋鎮", "大林鎮", "民雄鄉", "溪口鄉", "新港鄉", "六腳鄉", "東石鄉", "義竹鄉", "鹿草鄉", "水上鄉", "中埔鄉", "竹崎鄉", "梅山鄉", "番路鄉", "大埔鄉", "阿里山鄉"
        ], [
            "東區", "西區"
        ], [
            "中西區", "東區", "南區", "北區", "安平區", "安南區", "永康區", "歸仁區", "新化區", "左鎮區", "玉井區", "楠西區", "南化區", "仁德區", "關廟區", "龍崎區", "官田區", "麻豆區", "佳里區", "西港區", "七股區", "將軍區", "學甲區", "北門區", "新營區", "後壁區", "白河區", "東山區", "六甲區", "下營區", "柳營區", "鹽水區", "善化區", "大內區", "山上區", "新市區", "安定區"
        ], [
            "楠梓區", "左營區", "鼓山區", "三民區", "鹽埕區", "前金區", "新興區", "苓雅區", "前鎮區", "小港區", "旗津區", "鳳山區", "大寮區", "鳥松區", "林園區", "仁武區", "大樹區", "大社區", "岡山區", "路竹區", "橋頭區", "梓官區", "彌陀區", "永安區", "燕巢區", "田寮區", "阿蓮區", "茄萣區", "湖內區", "旗山區", "美濃區", "內門區", "杉林區", "甲仙區", "六龜區", "茂林區", "桃源區", "那瑪夏區"
        ],
                                  [
            "屏東市", "潮州鎮", "東港鎮", "恆春鎮", "萬丹鄉", "長治鄉", "麟洛鄉", "九如鄉", "里港鄉", "鹽埔鄉", "高樹鄉", "萬巒鄉", "內埔鄉", "竹田鄉", "新埤鄉", "枋寮鄉", "新園鄉", "崁頂鄉", "林邊鄉", "南州鄉", "佳冬鄉", "琉球鄉", "車城鄉", "滿州鄉", "枋山鄉", "霧台鄉", "瑪家鄉", "泰武鄉", "來義鄉", "春日鄉", "獅子鄉", "牡丹鄉", "三地門鄉"
        ], [
            "宜蘭市", "羅東鎮", "蘇澳鎮", "頭城鎮", "礁溪鄉", "壯圍鄉", "員山鄉", "冬山鄉", "五結鄉", "三星鄉", "大同鄉", "南澳鄉"
        ], [
            "花蓮市", "鳳林鎮", "玉里鎮", "新城鄉", "吉安鄉", "壽豐鄉", "秀林鄉", "光復鄉", "豐濱鄉", "瑞穗鄉", "萬榮鄉", "富里鄉", "卓溪鄉"
        ], [
            "臺東市", "成功鎮", "關山鎮", "長濱鄉", "海端鄉", "池上鄉", "東河鄉", "鹿野鄉", "延平鄉", "卑南鄉", "金峰鄉", "大武鄉", "達仁鄉", "綠島鄉", "蘭嶼鄉", "太麻里鄉"
        ], [
            "馬公市", "湖西鄉", "白沙鄉", "西嶼鄉", "望安鄉", "七美鄉"
        ],
                                  [
            "金城鎮", "金湖鎮", "金沙鎮", "金寧鄉", "烈嶼鄉", "烏坵鄉"
        ], [
            "南竿鄉", "北竿鄉", "莒光鄉", "東引鄉"
        ]]
    var firstSelected: String = ""
    var second: [String] = []
    var secondSelected: String = ""
    
    var decorateStyle: String?
    var location: String?
    var sizeMax: Int?
    var sizeMin: Int?
    var replyMin: Int?
    var replyMax: Int?
    var loveMin: Int?
    var loveMax: Int?
    
    func viewAddTapGesture() {
        let singleFinger = UITapGestureRecognizer(target:self, action:#selector(singleTap))

        singleFinger.numberOfTapsRequired = 1

        singleFinger.numberOfTouchesRequired = 1
    
        dismissView.addGestureRecognizer(singleFinger)
    }
    
    @IBAction func didTouchSet(_ sender: Any) {
        guard let tabVC = self.presentingViewController as? STTabBarViewController else { return }
        guard let navVC = tabVC.selectedViewController as? UINavigationController else { return }
        guard let articleVC = navVC.topViewController as? ArticleViewController else { return }
        var fitlerArticles = articleVC.articlesData
        
        for condition in conditionsArray {
            fitlerArticles = condition.filter(data: fitlerArticles)
        }
        
        articleVC.articlesData = fitlerArticles
        articleVC.articleTableView.reloadData()
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func didTouchReset(_ sender: Any) {
        conditionsArray = []
        firstSelected = ""
        secondSelected = ""
        tableView.reloadData()
    }
    
    @objc func singleTap() {
//        UIView.animate(withDuration: 5, delay: 1, options: .curveEaseInOut, animations: {
//            self.contentViewLeading.constant = 0
//        }, completion: nil)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCollectionTableViewCell", for: indexPath) as? FilterCollectionTableViewCell else { return UITableViewCell() }
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.lk_registerCellWithNib(identifier: "FilterCollectionViewCell", bundle: nil)
            cell.collectionView.reloadData()
            return cell
        } else if indexPath.section == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterPickerTableViewCell", for: indexPath) as? FilterPickerTableViewCell else { return UITableViewCell() }
            cell.locationTextField.delegate = self
            cell.locationTextField.inputView = cell.pickerView
            cell.locationTextField.text = firstSelected + secondSelected
            cell.pickerView.delegate = self
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell", for: indexPath) as? FilterTableViewCell else { return UITableViewCell() }
            cell.minValueTextField.delegate = self
            cell.maxValueTextField.delegate = self
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
        let style = StyleCondition(conditionValue: styleText)
        conditionsArray =  conditionsArray.filter { element in
            
            if element as? StyleCondition == nil {
                return true
            }
            return false
        }
        conditionsArray.append(style)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell else { return }
        cell.backgroundColor = UIColor.assetColor(.shadowLightGray)
        cell.layer.borderWidth = 0
    }
}

extension FilterViewController: UITextFieldDelegate {
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
}

extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return first_level_area_data.count
        default:
            return second.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            firstSelected = first_level_area_data[row]
            second = second_level_area_data[row]
            pickerView.reloadComponent(1)
        } else {
            secondSelected = second[row]
            let locationString = firstSelected + secondSelected
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
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return first_level_area_data[row]
        }
        return second[row]
    }
}
