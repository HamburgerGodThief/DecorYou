//
//  ChatRoomViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/3.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class ChatRoomViewController: UIViewController {
    
    @IBOutlet weak var chatRoomTableView: UITableView!
    
    func setTableView() {
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
        chatRoomTableView.lk_registerCellWithNib(identifier: String(describing: ChatRoomTableViewCell.self), bundle: nil)
        chatRoomTableView.lk_registerCellWithNib(identifier: String(describing: ChatRoomSelfTableViewCell.self), bundle: nil)
        chatRoomTableView.separatorStyle = .none
        chatRoomTableView.rowHeight = UITableView.automaticDimension
        chatRoomTableView.estimatedRowHeight = 150
    }
    
    func setNavigationBar() {
        navigationItem.title = ""
        let btn = UIButton()
        btn.setTitle("    對象名稱", for: .normal)
        btn.setImage(UIImage.asset(.Icons_24px_Back02), for: .normal)
        btn.sizeToFit()
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(backToRoomList), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    func setBottomView() {
        let bottomView = UINib(nibName: "ChatRoomBottomView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! ChatRoomBottomView
        
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
    }
    
    @objc func backToRoomList() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setNavigationBar()
        setBottomView()
        
    }
}

extension ChatRoomViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2 {
            guard let selfCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChatRoomSelfTableViewCell.self), for: indexPath) as? ChatRoomSelfTableViewCell else { return UITableViewCell() }
            selfCell.messageLabel.text = "Test是在哈囉，loveloveyouyouloveyouLove<3<3<3<3 ^_^ >_^"
            return selfCell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChatRoomTableViewCell.self), for: indexPath) as? ChatRoomTableViewCell else { return UITableViewCell() }
        cell.messageLabel.text = "Test是在哈囉，loveloveyouyouloveyouLove<3<3<3<3 ^_^ >_^"
        
        return cell
    }
    
    
}
