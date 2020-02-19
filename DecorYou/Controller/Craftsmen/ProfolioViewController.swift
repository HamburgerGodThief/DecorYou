//
//  PortfolioViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/3.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class ProfolioViewController: UIViewController{
    
    @IBOutlet weak var profolioTableView: UITableView!
    var profolio: Profolio?
    var photoSet: [PhotoSet] = []
    let itemSpace = CGFloat(3)
    let columnCount = CGFloat(3)
    
    func setNavigationBar() {
        navigationItem.title = "幾房幾廳幾衛"
        navigationController?.navigationBar.titleTextAttributes =
        [.foregroundColor: UIColor.white,
         .font: UIFont(name: "PingFangTC-Medium", size: 18)!]
        let btn = UIButton()
        btn.setImage(UIImage.asset(.Icons_48px_Back01), for: .normal)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(backToResume), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    func reOrderProfolio() {
        guard let profolio = profolio else { return }
        photoSet = profolio.dataSet
        var finalSet: [PhotoSet] = []
        
        for set in photoSet {
            if set.images.isEmpty != true {
                finalSet.append(set)
            }
        }
        
        photoSet = finalSet
        
        profolioTableView.reloadData()
    }
    
    @objc func backToResume() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profolioTableView.lk_registerCellWithNib(identifier: String(describing: ProfolioTableViewCell.self), bundle: nil)
        profolioTableView.delegate = self
        profolioTableView.dataSource = self
        setNavigationBar()
        reOrderProfolio()
    }
}

extension ProfolioViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.view.bounds.height / 4
        return height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return photoSet.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return photoSet[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfolioTableViewCell.self), for: indexPath) as? ProfolioTableViewCell else { return UITableViewCell() }
        cell.profolioCollectionView.delegate = self
        cell.profolioCollectionView.dataSource = self
        cell.profolioCollectionView.tag = indexPath.section
        cell.profolioCollectionView.lk_registerCellWithNib(identifier: String(describing: ResumeCollectionViewCell.self), bundle: nil)
        return cell
    }
    
}

extension ProfolioViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoSet[collectionView.tag].images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ResumeCollectionViewCell.self),
            for: indexPath
        ) as? ResumeCollectionViewCell else {
            
            return UICollectionViewCell()
        }
        cell.profolioImg.loadImage(photoSet[collectionView.tag].images[indexPath.item])
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(floor((collectionView.bounds.width - itemSpace * (columnCount-1)) / columnCount))
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }

    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return itemSpace
    }

    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return itemSpace
    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Craftsmen", bundle: nil)
//        guard let fullScreenViewController = storyboard.instantiateViewController(withIdentifier: "FullScreenViewController") as? FullScreenViewController else { return }
//        fullScreenViewController.modalPresentationStyle = .custom
//        fullScreenViewController.modalTransitionStyle = .crossDissolve
//        fullScreenViewController.imgSet = photoSet[collectionView.tag].images
//        navigationController?.pushViewController(fullScreenViewController, animated: true)
//    }
}
