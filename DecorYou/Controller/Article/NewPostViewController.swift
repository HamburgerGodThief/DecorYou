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
    var currentUser: User?
    let option = ["插入相片", "裝潢風格", "房屋地區", "房屋坪數", "合作業者"]
    let icon = [UIImage.asset(.Icons_24px_Album),
                UIImage.asset(.Icons_24px_DecorateStyle),
                UIImage.asset(.Icons_24px_Location),
                UIImage.asset(.Icons_24px_HomeSize),
                UIImage.asset(.Icons_24px_Craftsmen)]
    
    func setNavigationBar() {
        navigationItem.title = "發表文章"
        let rightBtn = UIBarButtonItem(title: "送出", style: .plain, target: self, action: #selector(createPost))
        let leftBtn = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelPost))
        navigationItem.rightBarButtonItem = rightBtn
        navigationItem.leftBarButtonItem = leftBtn
    }
    
    @objc func createPost() {
        guard let title = authorNameLabel.text else { return }
        guard let content = contentTextView.text else { return }
        guard let user = currentUser else { return }
        let currentDate = Date()
        ArticleManager.shared.addPost(title: title, content: content, loveCount: 0, reply: [], comment: [], authorName: user.name, authorUID: user.uid, createTime: currentDate)
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func cancelPost() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setIBOutlet() {
        authorImgView.layer.cornerRadius = authorImgView.frame.size.width / 2
        titleTextField.borderStyle = .none
        
        tableView.layer.cornerRadius = 20
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 1
        tableView.delegate = self
        tableView.dataSource = self
        tableView.lk_registerCellWithNib(identifier: String(describing: NewPostTableViewCell.self), bundle: nil)
        tableView.bounces = false
    }
    
    func getCurrentUser() {
        guard let uid = UserDefaults.standard.string(forKey: "UserToken") else { return }
        UserManager.shared.fetchCurrentUser(uid: uid, completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {

            case .success(let user):

                DispatchQueue.main.async {
                    strongSelf.authorNameLabel.text = "\(user.name)"
                    strongSelf.authorImgView.loadImage(user.img)
                    strongSelf.currentUser = user
                }

            case .failure(let error):

                print(error)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setIBOutlet()
        getCurrentUser()
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
