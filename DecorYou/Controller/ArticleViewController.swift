//
//  ArticleViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/1/22.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import Foundation
import UIKit

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var articleTableView: UITableView!
    
    func searchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "想找什麼呢..."
        navigationItem.titleView = searchBar
        
        let layoutBtn = UIBarButtonItem(image: UIImage.asset(.Icons_24px_CollectionView), style: .plain, target: self, action: #selector(changeLayout))
        let filterBtn = UIBarButtonItem(image: UIImage.asset(.Icons_24px_Filter), style: .plain, target: self, action: #selector(setfilter))
        navigationItem.rightBarButtonItems = [layoutBtn, filterBtn]
        navigationController?.navigationBar.backgroundColor = UIColor.brown
    }
    
    @objc func changeLayout() {
        
    }
    
    @objc func setfilter() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleTableView.delegate = self
        articleTableView.dataSource = self
        articleTableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: String(describing: ArticleTableViewCell.self))
        searchBar()
    }
}

extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleTableViewCell.self), for: indexPath) as? ArticleTableViewCell else { return UITableViewCell() }
//        cell.fillData(authorImgView: "https://www.impericon.com/en/iron-man-iron-man-mousepad.html", titleLabel: "這是標題", nameTimeLabel: "姓名 | 時間", contentLabel: "asalsa;kdjfl;aksdjfal;skdjfal;skdjfals;dkfjal;skdvmladksfnwlkjeroieqwj;flkamdva,.smvafl;kjdfl;awkeufoia;wfjadl;skfmclsd,v.madvnmalkedfjeiufgypwqioerutp034u98520345l234km.,/amdv,.asdjvlkasdjvakldfj3iour09341uirjeq;lwkfjmladsmvc.a/ds,vmj;akejfg302u50928349r[okmlemva/d.s,mva/s,.dfjal;kdsjfoiweuqporiuqpweorfje;lwkdm/d.s,vm/.,dsamcvakl;dfja;kwldfje0iur23904820[39r")
        return cell
    }

}
