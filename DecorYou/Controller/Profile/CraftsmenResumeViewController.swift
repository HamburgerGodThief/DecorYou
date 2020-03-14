//
//  CraftsmenResumeViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/5.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class CraftsmenResumeViewController: UIViewController {
    
    @IBOutlet weak var profolioCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var newProfolioBtn: UIButton!
    let transition = CircularTransition()
    var containerY: CGFloat = 0
    let itemSpace: CGFloat = 3
    let columnCount: CGFloat = 3
    var profolio: [Profolio] = []
    
    func setCollectionView() {
        profolioCollectionView.dataSource = self
        profolioCollectionView.delegate = self
        profolioCollectionView.lk_registerCellWithNib(identifier: String(describing: ResumeCollectionViewCell.self), bundle: nil)
    }
    
    @IBAction func didTouchCreate(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        guard let uploadProfolioViewController = storyboard.instantiateViewController(identifier: "UploadProfolioViewController") as? UploadProfolioViewController else { return }
        let nav = UINavigationController(rootViewController: uploadProfolioViewController)
        nav.transitioningDelegate = self
        nav.modalPresentationStyle = .custom
        present(nav, animated: true, completion: nil)
//        navigationController?.pushViewController(uploadProfolioViewController, animated: true)
    }
    
    @objc func fetchProfolio() {
        guard let uid = UserDefaults.standard.string(forKey: "UserToken") else { return }
        UserManager.shared.fetchSpecificCraftsmanProfolio(uid: uid, completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let profolio):
                strongSelf.profolio = profolio
                DispatchQueue.main.async {
                    if strongSelf.profolio.count == 0 {
                        strongSelf.labelShouldShow(shouldShow: true)
                    } else {
                        strongSelf.labelShouldShow(shouldShow: false)
                    }
                    strongSelf.profolioCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func labelShouldShow(shouldShow: Bool) {
        contentLabel.isHidden = !shouldShow
        titleLabel.isHidden = !shouldShow
    }
    
    @objc func backToProfile() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
        
        labelShouldShow(shouldShow: false)
        
        fetchProfolio()
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchProfolio), name: NSNotification.Name("UpdateProfolio"), object: nil)
    
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        newProfolioBtn.layer.cornerRadius = newProfolioBtn.frame.width / 2
    }
}

extension CraftsmenResumeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profolio.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ResumeCollectionViewCell.self), for: indexPath) as? ResumeCollectionViewCell else { return UICollectionViewCell() }
        cell.profolioImg.loadImage(profolio[indexPath.item].coverImg, placeHolder: UIImage(systemName: "person.crop.circle"))
        cell.profolioImg.tintColor = .lightGray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(floor((profolioCollectionView.bounds.width - itemSpace * (columnCount-1)) / columnCount))
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

extension CraftsmenResumeViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode = .present
        transition.circle.center = CGPoint(x: newProfolioBtn.center.x, y: newProfolioBtn.center.y + containerY)
        transition.startingPoint = transition.circle.center
        transition.circleColor = .white
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode = .dismiss
        
        return transition
    }
}
