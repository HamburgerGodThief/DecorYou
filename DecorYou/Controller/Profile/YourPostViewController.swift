//
//  YourPostViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/4.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class YourPostViewController: UIViewController {
    
    @IBOutlet weak var yourPostTableView: UITableView!
    var yourPost: [Article] = []
    
    func setTableView() {
        yourPostTableView.delegate = self
        yourPostTableView.dataSource = self
        yourPostTableView.lk_registerCellWithNib(identifier: String(describing: YourPostTableViewCell.self), bundle: nil)
        yourPostTableView.separatorStyle = .none
        yourPostTableView.estimatedRowHeight = 150
        yourPostTableView.rowHeight = UITableView.automaticDimension
        yourPostTableView.allowsSelection = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
}

extension YourPostViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yourPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: YourPostTableViewCell.self), for: indexPath) as? YourPostTableViewCell else { return UITableViewCell() }
        cell.collectionView.tag = indexPath.row
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.lk_registerCellWithNib(identifier: String(describing: YourPostCollectionViewCell.self), bundle: nil)
        return cell
    }
}

extension YourPostViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: YourPostCollectionViewCell.self), for: indexPath) as? YourPostCollectionViewCell else { return UICollectionViewCell() }
        cell.titleLabel.text = yourPost[collectionView.tag].title
        cell.timeLabel.text = yourPost[collectionView.tag].createTimeString
        cell.replyCountLabel.text = "20"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("test")

    }
}
