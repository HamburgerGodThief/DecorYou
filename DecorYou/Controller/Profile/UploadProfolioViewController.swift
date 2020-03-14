//
//  UploadProfolioViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/15.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit
import Photos
import FirebaseStorage
import FirebaseDatabase

struct UploadData {
    var areaTitle: String
    var areaPhoto: [UIImage]
}

class UploadProfolioViewController: UIViewController {
    
    @IBOutlet weak var newProfolioTableView: UITableView!
    
    var profolio = Profolio(coverImg: "",
                            livingRoom: [],
                            dinningRoom: [],
                            mainRoom: [],
                            firstRoom: [],
                            kitchen: [],
                            bathRoom: [],
                            totalArea: [],
                            createTime: Date())
    
    var selectAreaInTableView: [String] = [] {
        didSet {
            newProfolioTableView.reloadData()
        }
    }
    var selectedPhotoInTableView: [[UIImage]] = [] {
        didSet {
            newProfolioTableView.reloadData()
        }
    }
    var profolioMainImg = UIImageView()
    
    func setNav() {
        navigationItem.title = "新增作品"
        navigationController?.navigationBar.barTintColor = UIColor.assetColor(.mainColor)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white,
                                                                   .font: UIFont(name: "PingFangTC-Medium", size: 18)!]
        let rightBtn = UIBarButtonItem(title: "送出", style: .plain, target: self, action: #selector(createProfolio))
        let leftBtn = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
        rightBtn.tintColor = .white
        leftBtn.tintColor = .white
        navigationItem.rightBarButtonItem = rightBtn
        navigationItem.leftBarButtonItem = leftBtn
    }
    
    func setTableView() {
        newProfolioTableView.delegate = self
        newProfolioTableView.dataSource = self
        newProfolioTableView.lk_registerCellWithNib(identifier: String(describing: UploadProfolioTableViewCell.self), bundle: nil)
    }
    
    func setTableHeaderView() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(lbl)
        lbl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        lbl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        lbl.textAlignment = .center
        lbl.text = "請設定該作品封面照片"
        
        profolioMainImg.contentMode = .scaleAspectFill
        containerView.addSubview(profolioMainImg)
        profolioMainImg.translatesAutoresizingMaskIntoConstraints = false
        profolioMainImg.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        profolioMainImg.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        profolioMainImg.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        profolioMainImg.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addMainImg))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        profolioMainImg.addGestureRecognizer(tap)
        profolioMainImg.isUserInteractionEnabled = true
        
        newProfolioTableView.tableHeaderView = containerView
        
        containerView.widthAnchor.constraint(equalTo: newProfolioTableView.widthAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: newProfolioTableView.leadingAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: newProfolioTableView.topAnchor).isActive = true
        containerView.layoutIfNeeded()
    }
    
    func setTableFooterView() {
        //customView是footerView
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        
        //button設定 & 放進去customView
        button.setTitle("＋ 新增區域", for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "＋ 新增區域", attributes: [
        .foregroundColor: UIColor.black,
        .font: UIFont(name: "PingFangTC-Medium", size: 14)!]), for: .normal)
        button.addTarget(self, action: #selector(newArea), for: .touchUpInside)
        
        customView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: customView.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
        newProfolioTableView.tableFooterView = customView
        
        customView.layer.borderColor = UIColor.lightGray.cgColor
        customView.layer.borderWidth = 1
        
        newProfolioTableView.tableFooterView?.alpha = 0
    }
    
    @objc func createProfolio() {
        
        var uploadDatas: [UploadData] = []
        for order in 0..<selectAreaInTableView.count {
            uploadDatas.append(UploadData(areaTitle: selectAreaInTableView[order], areaPhoto: selectedPhotoInTableView[order]))
        }
        
        for data in uploadDatas {
            if data.areaTitle == "" || data.areaPhoto.isEmpty {
                let alertController = UIAlertController(title: "錯誤", message: "請先選擇照片與區域才可上傳", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
                return
            }
        }
        
        //上傳作品封面照片
        let areaGroup = DispatchGroup()
        let uniqueString = NSUUID().uuidString

        if let selectedImage = profolioMainImg.image {

            let storageRef = Storage.storage().reference().child("ProfolioMain").child("\(uniqueString).png")

            if let uploadData = selectedImage.pngData() {
                areaGroup.enter()
                storageRef.putData(uploadData, metadata: nil, completion: { (_, error) in

                    if error != nil {

                        print("Error: \(error!.localizedDescription)")
                        return
                    }

                    storageRef.downloadURL(completion: { [weak self] (url, _) in
                        guard let strongSelf = self else { return }
                        guard let imgURL = url?.absoluteString else { return }
                        strongSelf.profolio.coverImg = imgURL
                        areaGroup.leave()
                    })
                })
            }
        }
        
        //上傳作品區域照片
        for uploadData in uploadDatas {
            areaGroup.enter()
            var urlAry: [String] = []
            let group = DispatchGroup()
            for img in uploadData.areaPhoto {
                if let uploadImg = img.pngData() {
                    let uniqueString = NSUUID().uuidString
                    let storageRef = Storage.storage().reference().child("Profile").child("\(uniqueString).png")
                    // 這行就是 FirebaseStorage 關鍵的存取方法。
                    group.enter()
                    storageRef.putData(uploadImg, metadata: nil, completion: { (_, error) in
                        
                        if error != nil {
                            
                            // 若有接收到錯誤，我們就直接印在 Console 就好，在這邊就不另外做處理。
                            print("Error: \(error!.localizedDescription)")
                            return
                        }
                        
                        //將圖片的URL放到Cloud Firestore
                        storageRef.downloadURL(completion: {(url, _) in
                            guard let imgURL = url?.absoluteString else { return }
                            urlAry.append(imgURL)
                            group.leave()
                        })
                    })
                }
            }
            group.notify(queue: .main) {
                if uploadData.areaTitle == "客廳" {
                    self.profolio.livingRoom = urlAry
                    self.profolio.totalArea.append("客廳")
                } else if uploadData.areaTitle == "餐廳" {
                    self.profolio.dinningRoom = urlAry
                    self.profolio.totalArea.append("餐廳")
                } else if uploadData.areaTitle == "主臥室" {
                    self.profolio.mainRoom = urlAry
                    self.profolio.totalArea.append("主臥室")
                } else if uploadData.areaTitle == "房間一" {
                    self.profolio.firstRoom = urlAry
                    self.profolio.totalArea.append("房間一")
                } else if uploadData.areaTitle == "廚房" {
                    self.profolio.kitchen = urlAry
                    self.profolio.totalArea.append("廚房")
                } else if uploadData.areaTitle == "浴廁" {
                    self.profolio.bathRoom = urlAry
                    self.profolio.totalArea.append("浴廁")
                }
                areaGroup.leave()
            }
            
        }
        areaGroup.notify(queue: .main) { [weak self] in
            guard let strongSelf = self else { return }
            UserManager.shared.addProfolio(profolio: strongSelf.profolio)
            NotificationCenter.default.post(name: Notification.Name("UpdateProfolio"), object: nil)
            strongSelf.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func newArea() {
        if selectAreaInTableView.count == 0 && selectedPhotoInTableView.count == 0 {
            selectedPhotoInTableView.append([])
            selectAreaInTableView.append("")
        } else {
            guard let lastArea = selectAreaInTableView.last else { return }
            guard let lastPhotos = selectedPhotoInTableView.last else { return }
            if lastArea == "" || lastPhotos.isEmpty {
                let alertController = UIAlertController(title: "錯誤", message: "請先選擇照片與區域才可新增新的區域", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
            } else {
                selectedPhotoInTableView.append([])
                selectAreaInTableView.append("")
            }
        }
    }
    
    @objc func removeCell(sender: UIButton) {
        guard let cell = sender.superview?.superview as? UploadProfolioTableViewCell else { return }
        guard let indexPath = newProfolioTableView.indexPath(for: cell) else { return }
        selectedPhotoInTableView.remove(at: indexPath.row)
        selectAreaInTableView.remove(at: indexPath.row)
        newProfolioTableView.reloadData()
    }
    
    @objc func addMainImg(recognizer: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        setTableView()
        setTableHeaderView()
        setTableFooterView()
    }
}

extension UploadProfolioViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedPhotoInTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UploadProfolioTableViewCell.self), for: indexPath) as? UploadProfolioTableViewCell else { return UITableViewCell() }
        cell.cellVC = self
        cell.indexPathRow = indexPath.row
        cell.pickerView.tag = indexPath.row
        cell.removeBtn.addTarget(self, action: #selector(removeCell), for: .touchUpInside)
        cell.areaTextField.text = selectAreaInTableView[indexPath.row]
        cell.selectedPhotos = selectedPhotoInTableView[indexPath.row]
        cell.newPhotoCollectionView.reloadData()
        return cell
    }
}

extension UploadProfolioViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        // 取得從 UIImagePickerController 選擇的檔案
        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = pickedImage
            profolioMainImg.image = selectedImageFromPicker
            newProfolioTableView.tableFooterView?.alpha = 1
        }
        
        dismiss(animated: true, completion: nil)
        
    }
}
