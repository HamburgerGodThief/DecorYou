//
//  PhotosViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/16.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit
import Photos

class PhotosViewController: UIViewController {
    
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    var photoArray: [UIImage] = []
    let itemSpace = CGFloat(3)
    let columnCount = CGFloat(3)
    var parentVC: UploadProfolioViewController?
    var selectedPhotos: [UIImage] = []
    
    @IBAction func closePhotosVC(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func fetchPhotosFromGallery() {
        
        let imgManager = PHImageManager.default()
        
        let imgRequestOption = PHImageRequestOptions()
        imgRequestOption.isSynchronous = true
        imgRequestOption.deliveryMode = .opportunistic
        
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOption)
            
        if fetchResult.count > 0 {
            
            for order in 0..<fetchResult.count {
                imgManager.requestImage(for: fetchResult.object(at: order) ,
                                        targetSize: CGSize(width: 200, height: 200),
                                        contentMode: .aspectFill,
                                        options: imgRequestOption,
                                        resultHandler: { [weak self] (img, err) in
                                            guard let strongSelf = self else { return }
                                            guard let img = img else { return }
                                            strongSelf.photoArray.append(img)
                                            
                })
            }
            
            
        } else {
            print("You don't pick any photo.")
            photoCollectionView.reloadData()
        }
            
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.lk_registerCellWithNib(identifier: String(describing: PhotosCollectionViewCell.self), bundle: nil)
        fetchPhotosFromGallery()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let parentVC = parentVC else { return }
        parentVC.selectedPhotos = selectedPhotos
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotosCollectionViewCell.self), for: indexPath) as? PhotosCollectionViewCell else { return UICollectionViewCell() }
        cell.photoImg.image = photoArray[indexPath.item]
        guard let img = cell.photoImg.image else { return cell }
        if selectedPhotos.contains(img) {
            cell.photoImg.alpha = 0.5
            cell.numberLabel.backgroundColor = UIColor.assetColor(.mainColor)
            let index = selectedPhotos.firstIndex(of: img)
            cell.numberLabel.text = "\(index! + 1)"
        } else {
            cell.photoImg.alpha = 1
            cell.numberLabel.backgroundColor = .clear
            cell.numberLabel.text = nil
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(floor((collectionView.bounds.width - itemSpace * (columnCount-1)) / columnCount))
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
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotosCollectionViewCell else {
            return
        }
        guard let selectImg = cell.photoImg.image else { return }
        if selectedPhotos.contains(selectImg) {
            guard let index = selectedPhotos.firstIndex(of: selectImg) else { return }
            selectedPhotos.remove(at: index)
        } else {
            selectedPhotos.append(selectImg)
        }
        collectionView.reloadData()
    }
}

