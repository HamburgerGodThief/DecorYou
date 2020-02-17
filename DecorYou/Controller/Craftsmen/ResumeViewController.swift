//
//  ResumeViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/1/31.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class ResumeViewController: UIViewController {
    
    @IBOutlet weak var resumeCollectionView: UICollectionView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var chatBtn: UIButton!
    var craftsman: User?
    var allProfolio: [Profolio] = []
    let itemSpace: CGFloat = 3
    let columnCount: CGFloat = 3
    
    @IBAction func startConversation(_ sender: Any) {
        guard let chatViewController = UIStoryboard.chat.instantiateInitialViewController() as? ChatViewController else { return }
        navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    func setNavigationBar() {
        navigationItem.title = craftsman?.name
        navigationController?.navigationBar.titleTextAttributes =
        [.foregroundColor: UIColor.white,
         .font: UIFont(name: "PingFangTC-Medium", size: 18)!]
        let btn = UIButton()
        btn.setImage(UIImage.asset(.Icons_48px_Back01), for: .normal)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(backToCraftsmen), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    func getDataAndShowIt() {
        guard let craftsman = craftsman else { return }
        logoImg.loadImage(craftsman.img)
        guard let serviceCat = craftsman.serviceCategory else { return }
        serviceLabel.text = "服務項目: \(serviceCat)"
        
        UserManager.shared.fetchSpecificCraftsmanProfolio(uid: craftsman.uid, completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let allProfolio):
                strongSelf.allProfolio = allProfolio
                strongSelf.resumeCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        })
    }
    
    @objc func backToCraftsmen() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataAndShowIt()
        logoImg.layer.cornerRadius = logoImg.frame.size.width / 2
        setNavigationBar()
        resumeCollectionView.dataSource = self
        resumeCollectionView.delegate = self
        resumeCollectionView.lk_registerCellWithNib(identifier: String(describing: ResumeCollectionViewCell.self), bundle: nil)
    }
    
}

extension ResumeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allProfolio.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ResumeCollectionViewCell.self), for: indexPath) as? ResumeCollectionViewCell else { return UICollectionViewCell() }
        cell.portfolioImg.loadImage(allProfolio[indexPath.item].dinningRoom.first)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(floor((resumeCollectionView.bounds.width - itemSpace * (columnCount-1)) / columnCount))
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return itemSpace
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return itemSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Craftsmen", bundle: nil)
        guard let portfolioViewController = storyboard.instantiateViewController(withIdentifier: "PortfolioViewController") as? PortfolioViewController else { return }

        navigationController?.pushViewController(portfolioViewController, animated: true)
        
    }
}
