//
//  NewPostViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/1/31.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var authorImgView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    var currentUser: User?
    let option = ["插入相片", "裝潢風格", "房屋地區", "房屋坪數", "合作業者"]
    let icon = [UIImage.asset(.Icons_24px_Album),
                UIImage.asset(.Icons_24px_DecorateStyle),
                UIImage.asset(.Icons_24px_Location),
                UIImage.asset(.Icons_24px_HomeSize),
                UIImage.asset(.Icons_24px_Craftsmen)]
    var decorateStyle: [String] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    var location: String? {
        didSet {
            tableView.reloadData()
        }
    }
    var size: String? {
        didSet {
            tableView.reloadData()
        }
    }
    var collaborator: [Craftsmen] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    func setNavigationBar() {
        navigationItem.title = "發表文章"
        let rightBtn = UIBarButtonItem(title: "送出", style: .plain, target: self, action: #selector(createPost))
        let leftBtn = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelPost))
        navigationItem.rightBarButtonItem = rightBtn
        navigationItem.leftBarButtonItem = leftBtn
    }
    
    @objc func createPost() {
        guard let title = authorNameLabel.text else { return }
        guard let content = contentTextView.text else { return }
        guard let user = currentUser else { return }
        let currentDate = Date()
        ArticleManager.shared.addPost(title: title, content: content, loveCount: 0, reply: [], comment: [], authorName: user.name, authorUID: user.uid, createTime: currentDate, decorateStyle: decorateStyle, location: location, size: size, collaborator: collaborator)
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func cancelPost() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setIBOutlet() {
        authorImgView.layer.cornerRadius = authorImgView.frame.size.width / 2
        titleTextField.borderStyle = .none
        
        tableView.layer.cornerRadius = 20
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 1
        tableView.delegate = self
        tableView.dataSource = self
        tableView.lk_registerCellWithNib(identifier: String(describing: NewPostTableViewCell.self), bundle: nil)
        tableView.bounces = false
    }
    
    func getCurrentUser() {
        guard let uid = UserDefaults.standard.string(forKey: "UserToken") else { return }
        UserManager.shared.fetchCurrentUser(uid: uid, completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {

            case .success(let user):

                DispatchQueue.main.async {
                    strongSelf.authorNameLabel.text = "\(user.name)"
                    strongSelf.authorImgView.loadImage(user.img)
                    strongSelf.currentUser = user
                }

            case .failure(let error):

                print(error)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setIBOutlet()
        getCurrentUser()
    }
    
}


extension NewPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewPostTableViewCell.self), for: indexPath) as? NewPostTableViewCell else { return UITableViewCell() }
        guard let unwrapIcon = icon[indexPath.row] else { return UITableViewCell() }
        cell.fillData(iconImg: unwrapIcon, optionLabelText: option[indexPath.row])
        cell.logoCollectionView.isHidden = true
        if indexPath.row == 0 {
            cell.ugcLabel.isHidden = true
        } else if indexPath.row == 1 {
            cell.ugcLabel.text = decorateStyle.reduce("", { finalText, text in
                return finalText + "\(text) "
            })
        } else if indexPath.row == 2 {
            cell.ugcLabel.text = location
        } else if indexPath.row == 3 && size != nil {
            cell.ugcLabel.text = "\(size ?? "")坪"
        } else if indexPath.row == 4 {
            cell.logoCollectionView.isHidden = false
            cell.logoCollectionView.delegate = self
            cell.logoCollectionView.dataSource = self
            cell.logoCollectionView.lk_registerCellWithNib(identifier: String(describing: CollaboratorLogoCollectionViewCell.self), bundle: nil)
            cell.logoCollectionView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Article", bundle: nil)
        if indexPath.row == 0 {
            
        } else if indexPath.row == 1 {
            guard let decorateStyleViewController = storyboard.instantiateViewController(withIdentifier: "DecorateStyleViewController") as? DecorateStyleViewController else { return }
            decorateStyleViewController.delegate = self
            present(decorateStyleViewController, animated: true, completion: nil)
        } else if indexPath.row == 2 {
            guard let locationViewController = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController else { return }
            locationViewController.delegate = self
            present(locationViewController, animated: true, completion: nil)
        } else if indexPath.row == 3 {
            guard let sizeViewController = storyboard.instantiateViewController(withIdentifier: "SizeViewController") as? SizeViewController else { return }
            sizeViewController.delegate = self
            present(sizeViewController, animated: true, completion: nil)
        } else if indexPath.row == 4 {
            guard let collaboratorController = storyboard.instantiateViewController(withIdentifier: "CollaboratorViewController") as? CollaboratorViewController else { return }
            collaboratorController.delegate = self
            present(collaboratorController, animated: true, completion: nil)
        }
    }
}

extension NewPostViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collaborator.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollaboratorLogoCollectionViewCell.self), for: indexPath) as? CollaboratorLogoCollectionViewCell else { return UICollectionViewCell() }
        cell.logoImg.loadImage(collaborator[indexPath.item].img)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height
        let width = height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

extension NewPostViewController: DecorateStyleViewControllerDelegate, LocationViewControllerDelegate, SizeViewControllerDelegate, CollaboratorViewControllerDelegate {
    
    func addDataToParentVC(_ decorateStyleViewController: DecorateStyleViewController) {
        decorateStyle = decorateStyleViewController.selectStyle
    }
    
    func removeDataToParentVC(_ decorateStyleViewController: DecorateStyleViewController) {
        decorateStyle = decorateStyleViewController.selectStyle
    }
    
    func passDataToParentVC(_ locationViewController: LocationViewController) {
        guard let first = locationViewController.firstSelected else { return }
        guard let second = locationViewController.secondSelected else { return }
        location = first + second
    }
    
    func passDataToParentVC(_ sizeViewController: SizeViewController) {
        guard let size = sizeViewController.sizeTextField.text else { return }
        self.size = size
    }
    
    func passDataToParentVC(_ collaboratorViewController: CollaboratorViewController) {
        self.collaborator = collaboratorViewController.selectPeople
    }
    
}
