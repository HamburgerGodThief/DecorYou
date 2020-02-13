//
//  CharacterPickViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/13.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class CharacterPickViewController: UIViewController {
    @IBOutlet weak var craftsmenBtn: UIButton!
    @IBOutlet weak var customerBtn: UIButton!
    
    @IBAction func pickCraftsmen(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        guard let pickCrafsmenViewController = storyboard.instantiateViewController(withIdentifier: "PickCraftsmenViewController") as? PickCraftsmenViewController else { return }
        navigationController?.pushViewController(pickCrafsmenViewController, animated: true)
    }
    
    @IBAction func pickCustomer(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        guard let pickCustomerViewController = storyboard.instantiateViewController(withIdentifier: "PickCustomerViewController") as? PickCustomerViewController else { return }
        navigationController?.pushViewController(pickCustomerViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        craftsmenBtn.layer.cornerRadius = 20
        customerBtn.layer.cornerRadius = 20
    }
}
