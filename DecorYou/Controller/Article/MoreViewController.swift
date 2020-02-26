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
    var parentVC: ReadPostViewController?
    let titleArray = ["重新整理", "回覆文章", "收藏文章", "回文章列表"]
    let iconArray = [UIImage(systemName: "goforward"),
                     UIImage(systemName: "text.bubble"),
                     UIImage(systemName: "heart"),
                     UIImage(systemName: "arrow.left")]
    
    func setTableView() {
        moreTBView.delegate = self
        moreTBView.dataSource = self
        moreTBView.lk_registerCellWithNib(identifier: String(describing: ProfileTableViewCell.self), bundle: nil)
        moreTBView.layer.cornerRadius = 50
        moreTBView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        moreTBView.bounces = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 4
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            parentVC?.getArticleInfo()
            parentVC?.readPostTableView.reloadData()
            dismiss(animated: true, completion: nil)
        case 1:
            dismiss(animated: true, completion: nil)
            let storyboard = UIStoryboard(name: "Article", bundle: nil)
            guard let replyViewController = storyboard.instantiateViewController(withIdentifier: "ReplyViewController") as? ReplyViewController else { return }
            replyViewController.thisMainArticle = parentVC?.article
            replyViewController.parentVC = parentVC
            parentVC?.navigationController?.pushViewController(replyViewController, animated: true)
        case 2:
            dismiss(animated: true, completion: nil)
            parentVC?.addFavoriteAction()
        default:
            dismiss(animated: true, completion: nil)
            
        }
    }
}
