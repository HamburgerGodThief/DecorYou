//
//  ProfileViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/1/22.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var shadowView: RoundCornerAndShadow!
    
    let functionLabelText = ["個人資訊", "收藏文章", "你的文章", "登出"]
    let withIdentifier = ["InfoViewController", "FavoriteViewController", "YourPostViewController"]
    
    func setNavigationBar() {
        navigationItem.title = "個人頁面"
    }
    
    func setTableView() {
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.lk_registerCellWithNib(identifier: String(describing: ProfileTableViewCell.self), bundle: nil)
        profileTableView.separatorStyle = .none
        profileTableView.bounces = false
        shadowView.layoutTableView(profileTableView, radius: 10, color: .black, offset: CGSize(width: 10, height: 10), opacity: 0.8, cornerRadius: 60)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setTableView()
        logoImg.layer.cornerRadius = logoImg.frame.width / 2
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileTableViewCell.self), for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        cell.functionLabel.text = functionLabelText[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            guard let infoViewController = storyboard.instantiateViewController(withIdentifier: "InfoViewController") as? InfoViewController else { return }
            present(infoViewController, animated: true, completion: nil)
        } else if indexPath.row == 1 {
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            guard let favoriteViewController = storyboard.instantiateViewController(withIdentifier: "FavoriteViewController") as? FavoriteViewController else { return }
            navigationController?.pushViewController(favoriteViewController, animated: true)
        } else if indexPath.row == 2 {
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            guard let yourPostViewController = storyboard.instantiateViewController(withIdentifier: "YourPostViewController") as? YourPostViewController else { return }
            navigationController?.pushViewController(yourPostViewController, animated: true)
        } else if indexPath.row == 3 {
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            guard let craftsmenResumeViewController = storyboard.instantiateViewController(withIdentifier: "CraftsmenResumeViewController") as? CraftsmenResumeViewController else { return }
            navigationController?.pushViewController(craftsmenResumeViewController, animated: true)
            tabBarController?.tabBar.isHidden = true
        }
        
    }
}
