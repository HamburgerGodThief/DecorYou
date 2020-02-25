//
//  NewProfileViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/24.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class NewProfileViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var coverBackgroundView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.delegate = self
            collectionView.dataSource = self
            
        }
        
    }
    var yourPostVC: YourPostViewController!
    var user: User?
    let customerTabTitle: [String] = ["你的文章", "收藏文章"]
    let craftsmenTabTitle: [String] = ["你的文章", "收藏文章", "作品集"]
    var finalTabTitle: [String] = []
    var selectStatus: [Bool] = []
    let indicator = UIView()

    func setIBOutlet() {
        coverBackgroundView.layer.cornerRadius = coverBackgroundView.frame.width / 2
        profileImg.layer.cornerRadius = profileImg.frame.width / 2
    }
    
    func indicatorUnderCollection() {
        
        indicator.backgroundColor = .black
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: indicator, attribute: .width, relatedBy: .equal, toItem: collectionView, attribute: .width, multiplier: 1 / CGFloat(finalTabTitle.count), constant: 0),
            NSLayoutConstraint(item: indicator, attribute: .height, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0, constant: 1),
            NSLayoutConstraint(item: indicator, attribute: .bottom, relatedBy: .equal, toItem: collectionView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: indicator, attribute: .leading, relatedBy: .equal, toItem: collectionView, attribute: .leading, multiplier: 1, constant: 0)
        ])
    }
    
    func configureYourPostVC() {
        if yourPostVC == nil {
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            yourPostVC = storyboard.instantiateViewController(identifier: "YourPostViewController") as? YourPostViewController
        }
//        addChild(yourPostVC)
//        containerView.insertSubview(yourPostVC.view, at: 0)
//        yourPostVC.didMove(toParent: self)
//
//        yourPostVC.view.translatesAutoresizingMaskIntoConstraints = false
//        yourPostVC.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
//        yourPostVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
//        yourPostVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
//        yourPostVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
    
    func buildYourPostVC(strongSelf: NewProfileViewController) {
        strongSelf.yourPostVC.user = strongSelf.user
         
         strongSelf.addChild(strongSelf.yourPostVC)
         strongSelf.containerView.insertSubview(strongSelf.yourPostVC.view, at: 0)
         strongSelf.yourPostVC.didMove(toParent: self)
         
         strongSelf.yourPostVC.view.translatesAutoresizingMaskIntoConstraints = false
         strongSelf.yourPostVC.view.topAnchor.constraint(equalTo: strongSelf.containerView.topAnchor).isActive = true
         strongSelf.yourPostVC.view.bottomAnchor.constraint(equalTo: strongSelf.containerView.bottomAnchor).isActive = true
         strongSelf.yourPostVC.view.leadingAnchor.constraint(equalTo: strongSelf.containerView.leadingAnchor).isActive = true
        strongSelf.yourPostVC.view.trailingAnchor.constraint(equalTo: strongSelf.containerView.trailingAnchor).isActive = true
    }
    
    func getUserInfo() {
        guard let uid = UserDefaults.standard.string(forKey: "UserToken") else { return }
        UserManager.shared.fetchCurrentUser(uid: uid, completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let user):
                strongSelf.user = user
                
                strongSelf.profileImg.loadImage(user.img, placeHolder: UIImage())
                strongSelf.profileNameLabel.text = user.name
                if strongSelf.user?.character == "craftsmen" {
                    strongSelf.finalTabTitle = strongSelf.craftsmenTabTitle
                    strongSelf.selectStatus = [true, false, false]
                    strongSelf.indicatorUnderCollection()
                } else {
                    strongSelf.finalTabTitle = strongSelf.customerTabTitle
                    strongSelf.selectStatus = [true, false]
                    strongSelf.indicatorUnderCollection()
                }
                strongSelf.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setIBOutlet()
        configureYourPostVC()
        getUserInfo()
        
    }
    
}

extension NewProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return finalTabTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: NewProfileCollectionViewCell.self), for: indexPath) as? NewProfileCollectionViewCell else { return UICollectionViewCell() }
        
        cell.tabTitleLabel.text = finalTabTitle[indexPath.item]

        cell.tabTitleLabel.textColor = selectStatus[indexPath.item] ? .black : .lightGray
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(floor((collectionView.bounds.width / CGFloat(finalTabTitle.count))))
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for index in 0..<selectStatus.count {
            selectStatus[index] = false
        }
        selectStatus[indexPath.item] = true
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.indicator.frame.origin.x = strongSelf.collectionView.frame.size.width * CGFloat(Double(indexPath.item) / Double(strongSelf.selectStatus.count))
            
        }, completion: nil)
                
        collectionView.reloadData()
    }
}
