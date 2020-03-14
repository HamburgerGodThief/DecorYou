//
//  CategoryViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/26.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.delegate = self
            
            tableView.dataSource = self
            
            tableView.lk_registerCellWithNib(identifier: "CategoryTableViewCell", bundle: nil)
            
            tableView.separatorStyle = .none
            
        }
        
    }
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    var selectedCell: [CategoryTableViewCell] = []
    
    let catData: [String] = ["室內設計師", "木工師傅", "水電師傅",
                             "油漆師傅", "弱電師傅", "園藝設計師", "其他"]
    
    var appleIDFamilyName: String = ""
    
    var appleIDFirstName: String = ""
    
    var appleIDEmail: String = ""
    
    var appleUID: String = ""
    
    var signInType: String = ""
    
    @IBAction func touchConfirm(_ sender: Any) {
        
        if selectedCell.isEmpty {
            
            let alertController = UIAlertController(title: "錯誤", message: "請選擇職業", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            guard let areaVC = storyboard.instantiateViewController(identifier: AuthViewControllers.areaViewController.rawValue) as? AreaViewController else { return }
            areaVC.categoryType = selectedCell[0].cateLabel.text!
            
            areaVC.appleIDFamilyName = appleIDFamilyName
            
            areaVC.appleIDFirstName = appleIDFirstName
            
            areaVC.appleIDEmail = appleIDEmail
            
            areaVC.appleUID = appleUID
            
            areaVC.signInType = signInType
            
            navigationController?.pushViewController(areaVC, animated: true)
            
        }
        
    }
    
    @IBAction func touchBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
        cell.cateLabel.text = catData[indexPath.row]
        
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
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell else { return }
        cell.select = !cell.select
        cell.cateLabel.textColor = cell.select ? .white : UIColor.assetColor(.mainColor)
        cell.backView.backgroundColor = cell.select ? UIColor.assetColor(.mainColor) : .white
        cell.backView.layer.borderColor = cell.select ? UIColor.assetColor(.shadowLightGray)?.cgColor : UIColor.assetColor(.mainColor)?.cgColor
        
        if selectedCell.contains(cell) {
            selectedCell.removeAll()
        } else {
            selectedCell.append(cell)
            if selectedCell.count > 1 {
                selectedCell.first?.select = false
                selectedCell.first?.cateLabel.textColor = cell.select ? UIColor.assetColor(.mainColor) : .white
                selectedCell.first?.backView.backgroundColor = cell.select ? .white : UIColor.assetColor(.mainColor)
                selectedCell.first?.backView.layer.borderColor = cell.select ? UIColor.assetColor(.mainColor)?.cgColor : UIColor.assetColor(.shadowLightGray)?.cgColor
                selectedCell.removeFirst()
            }
        }
        
    }
    
}
