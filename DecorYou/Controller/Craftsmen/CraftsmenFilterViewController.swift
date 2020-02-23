//
//  CraftsmenFilterViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/23.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class CraftsmenFilterViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var setBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dismissView: UIView!
    var conditionsArray: [CraftsmenConditionDelegate] = []
    
    @IBAction func didTouchSet(_ sender: Any) {
        
    }
    @IBAction func didTouchReset(_ sender: Any) {
        
    }
    
    func viewAddTapGesture() {
        let singleFinger = UITapGestureRecognizer(target:self, action:#selector(singleTap))

        singleFinger.numberOfTapsRequired = 1

        singleFinger.numberOfTouchesRequired = 1
    
        dismissView.addGestureRecognizer(singleFinger)
    }
    
    @objc func singleTap() {
//        UIView.animate(withDuration: 5, delay: 1, options: .curveEaseInOut, animations: {
//            self.contentViewLeading.constant = 0
//        }, completion: nil)
        dismiss(animated: false, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAddTapGesture()
        resetBtn.layer.borderColor = UIColor.assetColor(.mainColor)?.cgColor
        resetBtn.layer.borderWidth = 1
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.lk_registerCellWithNib(identifier: "FilterCollectionViewCell", bundle: nil)
    }
}

extension CraftsmenFilterViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {

            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: String(describing: DecorateStyleCollectionReusableView.self),
                for: indexPath
            )

            guard let decorateStyleView = header as? DecorateStyleCollectionReusableView else { return header }

            decorateStyleView.titleLabel.text = "至多選擇兩項"

            return decorateStyleView
        }

        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
}
