//
//  PortfolioViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/3.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class PortfolioViewController: UIViewController {
    
    @IBOutlet weak var portfolioTableView: UITableView!
    
    let area = ["客廳", "主臥室", "廚房", "次臥室"]
    
    func setNavigationBar() {
        let btn = UIButton()
        btn.titleLabel?.attributedText = NSAttributedString(string: "業者名字", attributes:
            [.foregroundColor: UIColor.white,
             .font: UIFont(name: "PingFangTC-Medium", size: 14)!])
        btn.setImage(UIImage.asset(.Icons_48px_Back01), for: .normal)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(backToResume), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    @objc func backToResume() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        portfolioTableView.lk_registerCellWithNib(identifier: String(describing: PortfolioTableViewCell.self), bundle: nil)
        portfolioTableView.delegate = self
        portfolioTableView.dataSource = self
        setNavigationBar()

    }
}

extension PortfolioViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.view.bounds.height / 4
        return height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return area.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return area[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PortfolioTableViewCell.self), for: indexPath) as? PortfolioTableViewCell else { return UITableViewCell() }
        return cell
    }
    
}
