//
//  CraftsmenResumeViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/5.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class CraftsmenResumeViewController: UIViewController {
    
    @IBOutlet weak var portfolioCollectionView: UICollectionView!
    @IBOutlet weak var createNewProfolioBtn: UIButton!
    let itemSpace: CGFloat = 3
    let columnCount: CGFloat = 3
    
    func setCollectionView() {
        portfolioCollectionView.dataSource = self
        portfolioCollectionView.delegate = self
        portfolioCollectionView.lk_registerCellWithNib(identifier: String(describing: ResumeCollectionViewCell.self), bundle: nil)
    }
    
    @IBAction func didTouchCreate(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        guard let uploadProfolioViewController = storyboard.instantiateViewController(identifier: "UploadProfolioViewController") as? UploadProfolioViewController else { return }
        navigationController?.pushViewController(uploadProfolioViewController, animated: true)
    }
    
    func setNavigationBar() {
        navigationItem.title = "你的作品"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white,
                                                                   .font: UIFont(name: "PingFangTC-Medium", size: 18)!]
        let leftbtn = UIButton()
        leftbtn.tintColor = .white
        leftbtn.setImage(UIImage.asset(.Icons_48px_Back01), for: .normal)
        leftbtn.sizeToFit()
        leftbtn.addTarget(self, action: #selector(backToProfile), for: .touchUpInside)
        let rightbtn = UIButton()
        rightbtn.tintColor = .white
        rightbtn.setTitle("edit", for: .normal)
        rightbtn.titleLabel?.attributedText = NSAttributedString(string: "edit",
                                                                 attributes: [.foregroundColor: UIColor.white,
                                                                              .font: UIFont(name: "PingFangTC-Medium", size: 14)!])
        rightbtn.sizeToFit()
        rightbtn.addTarget(self, action: #selector(editProfolio), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftbtn)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightbtn)
    }
    
    func setCreateBtn() {
        createNewProfolioBtn.layer.cornerRadius = createNewProfolioBtn.frame.width / 2
    }
    
//    func fetchProfolio() {
//        guard let uid = UserDefaults.standard.string(forKey: "UserToken") else { return }
//        UserManager.shared.fetchSpecificCraftsmanPortfolio(uid: <#T##String#>, completion: <#T##(Result<[Profolio], Error>) -> Void#>)
//    }
    
    @objc func editProfolio() {
        
    }
    
    @objc func backToProfile() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setCollectionView()
        setCreateBtn()
    }
}

extension CraftsmenResumeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 22
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ResumeCollectionViewCell.self), for: indexPath) as? ResumeCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(floor((portfolioCollectionView.bounds.width - itemSpace * (columnCount-1)) / columnCount))
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return itemSpace
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return itemSpace
    }
    
}
