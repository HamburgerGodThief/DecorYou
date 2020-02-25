//
//  FavoriteViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/4.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var favoriteTableView: UITableView!
    var lovePost: [Article] = []
    var user: User?
    
    func setTableView() {
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favoriteTableView.lk_registerCellWithNib(identifier: String(describing: FavoriteTableViewCell.self), bundle: nil)
        favoriteTableView.estimatedRowHeight = 100
        favoriteTableView.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        favoriteTableView.rowHeight = UITableView.automaticDimension
    }
    
    func getLovePost() {
        guard let user = UserManager.shared.user else { return }
        for lovePostRef in user.lovePost {
            ArticleManager.shared.fetchPostRef(postRef: lovePostRef, completion: { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let article):
                    strongSelf.lovePost.append(article)
                    strongSelf.favoriteTableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        getLovePost()
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lovePost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FavoriteTableViewCell.self), for: indexPath) as? FavoriteTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = lovePost[indexPath.row].title
        cell.authorAndTimeLabel.text = "作者: | time: "
        cell.replyCountLabel.text = "\(indexPath.row + 8)"
        return cell
    }
}
