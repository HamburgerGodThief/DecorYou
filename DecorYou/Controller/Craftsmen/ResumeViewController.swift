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
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nullImageView: UIImageView!
    @IBOutlet weak var nullLabel: UILabel!
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
        navigationController?.navigationBar.isTranslucent = false
        let btn = UIButton()
        btn.setImage(UIImage.asset(.Icons_48px_Back01), for: .normal)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(backToCraftsmen), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    func getDataAndShowIt() {
        guard let craftsman = craftsman else { return }
        logoImg.loadImage(craftsman.img, placeHolder: UIImage(systemName: "person.crop.circle"))
        logoImg.tintColor = .lightGray
        guard let serviceCat = craftsman.serviceCategory else { return }
        let location = craftsman.serviceLocation.reduce("", { (sum, string) -> String in
            return sum + string + "、"
        })
        serviceLabel.text = "職業: \(serviceCat)"
        locationLabel.text = "地區: \(location)"
        emailLabel.text = "電子信箱: \(craftsman.email)"
        
        UserManager.shared.fetchSpecificCraftsmanProfolio(uid: craftsman.uid, completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let allProfolio):
                strongSelf.allProfolio = allProfolio
                if strongSelf.allProfolio.count == 0 {
                    strongSelf.showNullAlert(shouldShow: false)
                }
                strongSelf.resumeCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func showNullAlert(shouldShow: Bool) {
        nullLabel.isHidden = shouldShow
        nullImageView.isHidden = shouldShow
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
        titleLabel.layer.borderColor = UIColor.lightGray.cgColor
        titleLabel.layer.borderWidth = 1
        nullImageView.isHidden = true
        nullLabel.isHidden = true
    }
    
}

extension ResumeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allProfolio.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ResumeCollectionViewCell.self), for: indexPath) as? ResumeCollectionViewCell else { return UICollectionViewCell() }
        cell.profolioImg.loadImage(allProfolio[indexPath.item].coverImg, placeHolder: UIImage(systemName: "person.crop.circle"))
        cell.profolioImg.tintColor = .lightGray
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
        guard let profolioViewController = storyboard.instantiateViewController(withIdentifier: "ProfolioTestViewController") as? ProfolioTestViewController else { return }
        profolioViewController.profolio = allProfolio[indexPath.item]
        navigationController?.pushViewController(profolioViewController, animated: true)
        
    }
}
