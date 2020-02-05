//
//  ReplyViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/5.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setNavigationBar() {
        navigationItem.title = "回覆文章"
        let rightBtn = UIBarButtonItem(title: "送出", style: .plain, target: self, action: #selector(createPost))
        let leftBtn = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelPost))
        navigationItem.rightBarButtonItem = rightBtn
        navigationItem.leftBarButtonItem = leftBtn
    }
    
    func setOutletContent() {
        logoImg.layer.cornerRadius = logoImg.frame.size.width / 2
        nameLabel.text = "User name"
    }
    
    @objc func createPost() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelPost() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setOutletContent()
    }
}
