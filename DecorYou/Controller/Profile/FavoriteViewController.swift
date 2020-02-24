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
    
    func setTableView() {
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favoriteTableView.lk_registerCellWithNib(identifier: String(describing: FavoriteTableViewCell.self), bundle: nil)
        favoriteTableView.estimatedRowHeight = 100
        favoriteTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
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
