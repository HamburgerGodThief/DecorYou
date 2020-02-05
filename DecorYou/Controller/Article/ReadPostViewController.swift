//
//  ReadPostViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/5.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class ReadPostViewController: UIViewController {
    
    @IBOutlet weak var readPostTableView: UITableView!
    let bottomView = UINib(nibName: "ReadPostBottomView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! ReadPostBottomView
    
    func setTableView() {
        readPostTableView.delegate = self
        readPostTableView.dataSource = self
        readPostTableView.lk_registerCellWithNib(identifier: String(describing: ReadPostTableViewCell.self), bundle: nil)
    }
    
    func setBottomView() {
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
    
    func setBottomViewAction() {
        bottomView.moreBtn.addTarget(self, action: #selector(moreVC), for: .touchUpInside)
        bottomView.replyBtn.addTarget(self, action: #selector(replyVC), for: .touchUpInside)
    }
    
    func setNavigationBar() {
        navigationItem.title = "文章title"
        let btn = UIButton()
        btn.setTitle("Back", for: .normal)
        btn.setImage(UIImage.asset(.Icons_24px_Back02), for: .normal)
        btn.sizeToFit()
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(backToArticle), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    @objc func backToArticle() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func moreVC() {
        let storyboard = UIStoryboard(name: "Article", bundle: nil)
        guard let moreViewController = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as? MoreViewController else { return }
        present(moreViewController, animated: true, completion: nil)
    }
    
    @objc func replyVC() {
        let storyboard = UIStoryboard(name: "Article", bundle: nil)
        guard let replyViewController = storyboard.instantiateViewController(withIdentifier: "ReplyViewController") as? ReplyViewController else { return }
        navigationController?.pushViewController(replyViewController, animated: true)
    }
    
    @objc func singleTap() {
        let storyboard = UIStoryboard(name: "Article", bundle: nil)
        guard let replyViewController = storyboard.instantiateViewController(withIdentifier: "ReplyViewController") as? ReplyViewController else { return }
        navigationController?.pushViewController(replyViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setNavigationBar()
        setBottomView()
        setBottomViewAction()
    }
}


extension ReadPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReadPostTableViewCell.self), for: indexPath) as? ReadPostTableViewCell else { return UITableViewCell() }
        return cell
    }
    
}
