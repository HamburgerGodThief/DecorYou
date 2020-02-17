//
//  ChatViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/1/22.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import Foundation
import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatListTableView: UITableView!
    
    func setNavigationBar() {
        navigationItem.title = "聊天列表"
        
        let leftBtn = UIBarButtonItem(title: "編輯", style: .plain, target: self, action: #selector(edit))
        navigationItem.leftBarButtonItem = leftBtn
        navigationController?.navigationBar.barTintColor = UIColor.assetColor(.mainColor)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
    }
    
    func setTableHeaderView() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let searchBar = UISearchBar()
        containerView.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "找誰呢..."
        searchBar.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        chatListTableView.tableHeaderView = containerView
        
        containerView.centerXAnchor.constraint(equalTo: chatListTableView.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: chatListTableView.widthAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: chatListTableView.topAnchor).isActive = true
        containerView.layoutIfNeeded()
    }
    
    @objc func edit() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setTableHeaderView()
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        chatListTableView.lk_registerCellWithNib(identifier: String(describing: ChatListTableViewCell.self), bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChatListTableViewCell.self), for: indexPath) as? ChatListTableViewCell else { return UITableViewCell() }
        cell.latestMessageLabel.text = "Row: \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        guard let charRoomViewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomViewController") as? ChatRoomViewController else { return }
        navigationController?.pushViewController(charRoomViewController, animated: true)
        charRoomViewController.tabBarController?.tabBar.isHidden = true
    }
    
}
