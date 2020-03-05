//
//  TextViewViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/3/5.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class TextViewViewController: UIViewController {

    @IBOutlet var toolBarView: UIView!
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func addPhoto(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        // 判斷是否可以從照片圖庫取得照片來源
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {

            // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.photoLibrary)，並 present UIImagePickerController
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.inputAccessoryView = toolBarView
        // Do any additional setup after loading the view.
    }
}

extension TextViewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
        var selectedImageFromPicker: UIImage?

        // 取得從 UIImagePickerController 選擇的檔案
        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = pickedImage
        }

        dismiss(animated: true, completion: nil)
        
    }
}
