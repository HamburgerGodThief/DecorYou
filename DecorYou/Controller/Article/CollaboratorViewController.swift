//
//  CollaboratorViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/8.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

protocol CollaboratorViewControllerDelegate: AnyObject {
    
    func passDataToParentVC(_ collaboratorViewController: CollaboratorViewController)
    
}

class CollaboratorViewController: UIViewController {

    @IBOutlet weak var collaboratorSearch: UISearchBar!
    @IBOutlet weak var collaboratorTableView: UITableView!
    @IBOutlet weak var collaboratorCollectionView: UICollectionView!
    weak var delegate: CollaboratorViewControllerDelegate?
    var allCraftsMen: [Craftsmen] = [] {
        didSet {
            collaboratorTableView.reloadData()
        }
    }
    var selectPeople: [Craftsmen] = [] {
        didSet {
            collaboratorCollectionView.reloadData()
        }
    }
    var selectedTableViewCell: [CollaboratorTableViewCell] = [] {
        didSet {
            collaboratorTableView.reloadData()
        }
    }
    
    @IBAction func didTouchCancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTouchConfirmBtn(_ sender: Any) {
        delegate?.passDataToParentVC(self)
        dismiss(animated: true, completion: nil)
    }
    
    func setCollectionView() {
        collaboratorCollectionView.delegate = self
        collaboratorCollectionView.dataSource = self
        collaboratorCollectionView.lk_registerCellWithNib(identifier: String(describing: CollaboratorCollectionViewCell.self), bundle: nil)
    }
    
    func setTableView() {
        collaboratorTableView.delegate = self
        collaboratorTableView.dataSource = self
        collaboratorTableView.lk_registerCellWithNib(identifier: String(describing: CollaboratorTableViewCell.self), bundle: nil)
    }
    
    func getAllCraftsmen() {
        UserManager.shared.fetchAllCraftsmen(completion: { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let craftmens):
                for craftmen in craftmens {
                    let data = Craftsmen(email: craftmen.email,
                                         name: craftmen.name,
                                         uid: craftmen.uid,
                                         img: craftmen.img,
                                         lovePost: craftmen.lovePost,
                                         selfPost: craftmen.selfPost,
                                         character: craftmen.character,
                                         serviceLocation: craftmen.serviceLocation,
                                         serviceCategory: craftmen.serviceCategory,
                                         select: false)
                    strongSelf.allCraftsMen.append(data)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setTableView()
        getAllCraftsmen()
    }
}

extension CollaboratorViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectPeople[indexPath.item].select = false
        selectPeople.remove(at: indexPath.item)
        selectedTableViewCell.remove(at: indexPath.item)
        collaboratorTableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectPeople.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollaboratorCollectionViewCell.self), for: indexPath) as? CollaboratorCollectionViewCell else { return UICollectionViewCell() }
        cell.nameLabel.text = selectPeople[indexPath.item].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 60
        let height = 100
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    }
    
}

extension CollaboratorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CollaboratorTableViewCell else { return }
        if selectedTableViewCell.contains(cell) {
            allCraftsMen[indexPath.row].select = false
            cell.selectedIcon.image = UIImage.init(systemName: "circle")
            guard let index = selectedTableViewCell.firstIndex(of: cell) else { return }
            selectedTableViewCell.remove(at: index)
            selectPeople.remove(at: index)
        } else {
            allCraftsMen[indexPath.row].select = true
            selectPeople.append(allCraftsMen[indexPath.row])
            cell.selectedIcon.image = UIImage.init(systemName: "checkmark.circle.fill")
            selectedTableViewCell.append(cell)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCraftsMen.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CollaboratorTableViewCell.self), for: indexPath) as? CollaboratorTableViewCell else { return UITableViewCell() }
        cell.nameLabel.text = allCraftsMen[indexPath.row].name
        if allCraftsMen[indexPath.row].select == true {
            cell.selectedIcon.image = UIImage.init(systemName: "checkmark.circle.fill")
        } else {
            cell.selectedIcon.image = UIImage.init(systemName: "circle")
        }
        return cell
    }
}
