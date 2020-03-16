//
//  FavoriteViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/4.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var noArticleLabel: UILabel!
    
    var lovePost: [Article] = []
    var user: User?
    
    func setTableView() {
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favoriteTableView.lk_registerCellWithNib(identifier: String(describing: YourPostTableViewCell.self), bundle: nil)
        favoriteTableView.separatorStyle = .none
        favoriteTableView.estimatedRowHeight = 180
        favoriteTableView.rowHeight = UITableView.automaticDimension
    }
    // swiftlint:disable all
    @objc func getLovePost() {
        lovePost = []
        let group0 = DispatchGroup()
        let group1 = DispatchGroup()
        let queue0 = DispatchQueue(label: "queue0")
        guard let user = UserManager.shared.user else { return }
        for lovePostRef in user.lovePost {
            group0.enter()
            ArticleManager.shared.fetchPostRef(postRef: lovePostRef, completion: { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let article):
                    strongSelf.lovePost.append(article)
                    group0.leave()
                case .failure(let error):
                    print(error)
                }
            })
        }
        
        group1.enter()
        group0.notify(queue: queue0) { [weak self] in
            guard let strongSelf = self else { return }
            for order in 0..<strongSelf.lovePost.count {
                group1.enter()
                ArticleManager.shared.fetchPostAuthorRef(authorRef: strongSelf.lovePost[order].author, completion: { result in
                    switch result {
                    case.success(let author):
                        strongSelf.lovePost[order].authorObject = author
                        group1.leave()
                    case.failure(let error):
                        print(error)
                    }
                })
            }
            group1.leave()
        }
        
        group1.notify(queue: .main) { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.lovePost.isEmpty {
                strongSelf.noArticleLabel.isHidden = false
            } else {
                strongSelf.noArticleLabel.isHidden = true
            }
            strongSelf.favoriteTableView.reloadData()
        }
    }
    // swiftlint:enable all
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        noArticleLabel.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(getLovePost), name: NSNotification.Name("UpdateUserManager"), object: nil)
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lovePost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: YourPostTableViewCell.self), for: indexPath) as? YourPostTableViewCell else { return UITableViewCell() }
        guard let authorOBJ = lovePost[indexPath.row].authorObject else { return UITableViewCell() }
        cell.typeLabel.text = "[\(lovePost[indexPath.row].type)]"
        cell.titleLabel.text = lovePost[indexPath.row].title
        cell.timeLabel.text = "\(authorOBJ.name) | \(lovePost[indexPath.row].createTimeString)"
        cell.loveLabel.text = "\(lovePost[indexPath.row].loveCount)"
        cell.replyLabel.text = "\(lovePost[indexPath.row].replyCount)"
        cell.backView.backgroundColor = UIColor.assetColor(.favoriteColor)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let spring = UISpringTimingParameters(dampingRatio: 0.5, initialVelocity: CGVector(dx: 1.0, dy: 0.2))
        let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: spring)
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: 100 * 0.6)
        animator.addAnimations {
            cell.alpha = 1
            cell.transform = .identity
            tableView.layoutIfNeeded()
        }
        animator.startAnimation(afterDelay: 0.1 * Double(indexPath.item))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Article", bundle: nil)
        guard let readPostVC = storyboard.instantiateViewController(identifier: "ReadPostViewController") as? ReadPostViewController else { return }
        readPostVC.article = lovePost[indexPath.row]
        present(readPostVC, animated: true, completion: nil)
    }
}
