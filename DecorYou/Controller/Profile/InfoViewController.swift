//
//  InfoViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/4.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var infoTableView: UITableView!
    let titleArray = ["User Name", "Email", "Gender", "Birth"]
    func setTableView() {
        infoTableView.delegate = self
        infoTableView.dataSource = self
        infoTableView.lk_registerCellWithNib(identifier: String(describing: InfoTableViewCell.self), bundle: nil)
        infoTableView.layer.cornerRadius = 50
        infoTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        infoTableView.backgroundColor = .brown
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
}

extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfoTableViewCell.self), for: indexPath) as? InfoTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = titleArray[indexPath.row]
        return cell
    }
    
    
}
