//
//  PickCraftsmenViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/13.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit
import Firebase

class PickCraftsmenViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var serviceCategoryTextField: UITextField!
    @IBOutlet weak var signUPBtn: UIButton!
    @IBOutlet weak var serviceAreaCollectionView: UICollectionView!
    var picker = UIPickerView()
    var selectAreaCell: [ServiceAreaCollectionViewCell] = []
    let pickerData: [String] = ["室內設計師", "木工師傅", "水電師傅",
                                "油漆師傅", "弱電師傅", "園藝設計師", "其他"]
    
    func setIBOutlet() {
        signUPBtn.layer.cornerRadius = 15
        nameTextField.addLine(position: LINE_POSITION.LINE_POSITION_BOTTOM, color: .white, width: 3)
        emailTextField.addLine(position: LINE_POSITION.LINE_POSITION_BOTTOM, color: .white, width: 3)
        passwordTextField.addLine(position: LINE_POSITION.LINE_POSITION_BOTTOM, color: .white, width: 3)
        serviceCategoryTextField.addLine(position: LINE_POSITION.LINE_POSITION_BOTTOM, color: .white, width: 3)
    }
    
    func setPickerView() {
        picker.delegate = self
        picker.dataSource = self
        serviceCategoryTextField.inputView = picker
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func didTouchSignUp(_ sender: Any) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text,
            let serviceCategory = serviceCategoryTextField.text else {
            
            let alertController = UIAlertController(title: "Error", message: "Input can't be empty", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error == nil {
                print("成功")
                
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                    guard let strongSelf = self else { return }
                    let user = Auth.auth().currentUser
                    guard let uid = user?.uid else { return }
                    UserDefaults.standard.set(uid, forKey: "UserToken")
                    UserDefaults.standard.set("craftsmen", forKey: "UserCharacter")
                    var location: [String] = []
                    for cell in strongSelf.selectAreaCell {
                        guard let text = cell.areaLabel.text else { return }
                        location.append(text)
                    }
                    let newUser = User(uid: uid,
                                       email: email,
                                       name: name,
                                       img: nil,
                                       lovePost: [],
                                       selfPost: [],
                                       character: "craftsmen",
                                       serviceLocation: location,
                                       serviceCategory: serviceCategory,
                                       select: false)
                    UserManager.shared.addUserData(uid: uid, user: newUser)
                    UserManager.shared.fetchCurrentUser(uid: uid)
                    guard let tabVC = strongSelf.presentingViewController as? STTabBarViewController else { return }
                    tabVC.selectedIndex = 3
                    strongSelf.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            } else {
                let alertController = UIAlertController(title: "Error", message: "This email already signed up.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func setNavigationBar() {
        navigationItem.title = ""
        let btn = UIButton()
        btn.setTitle(" Who You Are", for: .normal)
        btn.setImage(UIImage.asset(.Icons_24px_Back02), for: .normal)
        btn.tintColor = .white
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    func setCollectionView() {
        serviceAreaCollectionView.lk_registerCellWithNib(identifier: String(describing: ServiceAreaCollectionViewCell.self), bundle: nil)
        serviceAreaCollectionView.delegate = self
        serviceAreaCollectionView.dataSource = self
        
        let singleFinger = UITapGestureRecognizer(target:self, action:#selector(popServiceAreaVC))
        singleFinger.numberOfTapsRequired = 1
        singleFinger.numberOfTouchesRequired = 1
        serviceAreaCollectionView.addGestureRecognizer(singleFinger)
    }
    
    @objc func popServiceAreaVC() {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        guard let serviceAreaViewController = storyboard.instantiateViewController(withIdentifier: "ServiceAreaViewController") as? ServiceAreaViewController else { return }
        serviceAreaViewController.delegate = self
        present(serviceAreaViewController, animated: true, completion: nil)
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setIBOutlet()
        setNavigationBar()
        setCollectionView()
        setPickerView()
        // Do any additional setup after loading the view.
    }
}

extension PickCraftsmenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectAreaCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ServiceAreaCollectionViewCell.self), for: indexPath) as? ServiceAreaCollectionViewCell else { return UICollectionViewCell() }
        cell.layoutIfNeeded()
        cell.areaLabel.text = selectAreaCell[indexPath.item].areaLabel.text
        cell.areaLabel.backgroundColor = .lightGray
        cell.areaLabel.font.withSize(14)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 80
        let height = 32
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let left = CGFloat(0)
        let right = CGFloat(0)
        let top = CGFloat(0)
        let bottom = CGFloat(0)
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return 0
    }
    
}

extension PickCraftsmenViewController: ServiceAreaViewControllerDelegate {
    
    func passDataToParentVC(_ serviceAreaViewController: ServiceAreaViewController) {
        selectAreaCell = serviceAreaViewController.finalSelectCell
        serviceAreaCollectionView.reloadData()
    }
    
}

extension PickCraftsmenViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case pickerData.count - 1:
            serviceCategoryTextField.inputView = nil
            serviceCategoryTextField.text = ""
            serviceCategoryTextField.reloadInputViews()
            serviceCategoryTextField.inputView = picker
        default:
            serviceCategoryTextField.text = pickerData[row]
        }
        
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
}
