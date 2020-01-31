//
//  NewPostViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/1/31.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var authorImgView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    let option = ["插入相片", "裝潢風格", "房屋地區", "房屋坪數", "合作業者"]
    let icon = [UIImage.asset(.Icons_36px_Home_Normal),
                UIImage.asset(.Icons_36px_Home_Normal),
                UIImage.asset(.Icons_36px_Home_Normal),
                UIImage.asset(.Icons_36px_Home_Normal),
                UIImage.asset(.Icons_36px_Home_Normal)]
    
    func setNavigationBar() {
        
        navigationItem.title = "發表文章"
        let rightBtn = UIBarButtonItem(title: "送出", style: .plain, target: self, action: #selector(createPost))
        let leftBtn = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelPost))
        navigationItem.rightBarButtonItem = rightBtn
        navigationItem.leftBarButtonItem = leftBtn
        
    }
    
    @objc func createPost() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func cancelPost() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.lk_registerCellWithNib(identifier: String(describing: NewPostTableViewCell.self), bundle: nil)
    }
    
}


extension NewPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewPostTableViewCell.self), for: indexPath) as? NewPostTableViewCell else { return UITableViewCell() }
        guard let unwrapIcon = icon[indexPath.row] else { return UITableViewCell() }
        cell.fillData(iconImg: unwrapIcon, optionLabelText: option[indexPath.row])
        return cell
    }
    
}
