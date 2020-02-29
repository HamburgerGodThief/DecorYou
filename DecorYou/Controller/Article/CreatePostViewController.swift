//
//  CreatePostViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/27.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {

    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var articleCatBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var unboxHeight: NSLayoutConstraint!
    @IBOutlet weak var unboxVC: UIView!
    
    var currentUser: User?
    var articleType: String = "" {
        
        willSet {
            
            if newValue == "開箱" {
                unboxHeight.constant = 150
                unboxVC.alpha = 1
            } else {
                unboxHeight.constant = 0
                unboxVC.alpha = 0
            }
            view.layoutIfNeeded()
            
        }
        
    }
    
    @IBAction func touchArticleCat(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Article", bundle: nil)
        guard let articleTypeVC = storyboard.instantiateViewController(identifier: "ArticleTypeViewController") as? ArticleTypeViewController else { return }
        articleTypeVC.modalPresentationStyle = .overFullScreen
        articleTypeVC.parentVC = self
        present(articleTypeVC, animated: false, completion: nil)
    }
    
    func setIBOutlet() {
        let user = currentUser!
        logoImg.loadImage(user.img)
        nameLabel.text = user.name
        
        logoImg.layer.cornerRadius = logoImg.frame.width / 2
        articleCatBtn.backgroundColor = .clear
        articleCatBtn.layer.cornerRadius = articleCatBtn.frame.height / 2
        articleCatBtn.layer.borderColor = UIColor.assetColor(.mainColor)?.cgColor
        articleCatBtn.layer.borderWidth = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setIBOutlet()
        
    }
    
}

extension CreatePostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
