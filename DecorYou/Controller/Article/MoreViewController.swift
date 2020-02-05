//
//  MoreViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/5.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
    
    @IBOutlet weak var moreTBView: UITableView!
    let titleArray = ["重新整理", "回覆文章", "收藏文章", "回文章列表"]
    let iconArray = [UIImage.asset(.Icons_24px_Refresh),
                     UIImage.asset(.Icons_24px_AwaitingReview),
                     UIImage.asset(.Icons_24px_Favorite),
                     UIImage.asset(.Icons_24px_Back03)]
    
    func setTableView() {
        moreTBView.delegate = self
        moreTBView.dataSource = self
        moreTBView.lk_registerCellWithNib(identifier: String(describing: ProfileTableViewCell.self), bundle: nil)
        moreTBView.layer.cornerRadius = 50
        moreTBView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        moreTBView.backgroundColor = .brown
        moreTBView.bounces = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileTableViewCell.self), for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        cell.iconImg.image = iconArray[indexPath.row]
        cell.functionLabel.text = titleArray[indexPath.row]
        return cell
    }
}
