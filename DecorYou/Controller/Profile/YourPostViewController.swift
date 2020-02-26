//
//  YourPostViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/4.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class YourPostViewController: UIViewController {
    
    @IBOutlet weak var yourPostTableView: UITableView!
    var yourPost: [Article] = []
    var user: User?
    
    func setTableView() {
        yourPostTableView.delegate = self
        yourPostTableView.dataSource = self
        yourPostTableView.lk_registerCellWithNib(identifier: String(describing: YourPostTableViewCell.self), bundle: nil)
        yourPostTableView.separatorStyle = .none
        yourPostTableView.estimatedRowHeight = 150
        yourPostTableView.rowHeight = UITableView.automaticDimension
    }
    
    func getSelfPost() {
        guard let user = UserManager.shared.user else { return }
        for selfPostRef in user.selfPost {
            ArticleManager.shared.fetchPostRef(postRef: selfPostRef, completion: { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let article):
                    strongSelf.yourPost.append(article)
                    strongSelf.yourPostTableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        getSelfPost()
    }
}

extension YourPostViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yourPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: YourPostTableViewCell.self), for: indexPath) as? YourPostTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = yourPost[indexPath.row].title
        cell.timeLabel.text = yourPost[indexPath.row].createTimeString
        cell.loveLabel.text = "\(yourPost[indexPath.row].loveCount)"
        cell.replyLabel.text = "\(yourPost[indexPath.row].replyCount)"
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
}
