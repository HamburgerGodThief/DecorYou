//
//  TexeViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/27.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit



protocol TextViewControllerDelegate: AnyObject {
    func passToCreateVC(_ textViewController: TextViewController)
}

class TextViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.delegate = self
            
            tableView.dataSource = self
            
            tableView.separatorStyle = .none
            
            tableView.estimatedRowHeight = 150
            
            tableView.rowHeight = UITableView.automaticDimension
            
        }
        
    }
    
    @IBOutlet var toolBarView: UIView!
    
    var content: [NewPostData] = [NewPostTextView(text: "")]
    
    var currentIndexPath = IndexPath(row: 0, section: 0)
    
    @IBAction func addPhoto(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
            
        imagePickerController.delegate = self
        
        imagePickerController.sourceType = .photoLibrary

        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    @objc func removeImgCell(_ sender: UIButton) {
        
        guard let cell = sender.superview?.superview as? ImageViewTableViewCell else { return }
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        content.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

}

extension TextViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var global = UITableViewCell()
        
        if content[indexPath.row].cellType == .textView {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewTableViewCell", for: indexPath) as? TextViewTableViewCell else { return UITableViewCell() }
            
            cell.textView.delegate = self
            
            toolBarView.sizeToFit()
            
            cell.textView.inputAccessoryView = toolBarView
            
            cell.textView.isScrollEnabled = false
            
            global = cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewTableViewCell", for: indexPath) as? ImageViewTableViewCell else { return UITableViewCell() }
            
            if let image = content[indexPath.row] as? NewPostImage {
                
                cell.photoImg.image = image.image
                
                cell.photoImg.layer.borderColor = UIColor.assetColor(.mainColor)?.cgColor
                
                cell.photoImg.layer.borderWidth = 5
                
                cell.removeBtn.imageView?.contentMode = .scaleAspectFill
                
                cell.removeBtn.addTarget(self, action: #selector(removeImgCell), for: .touchUpInside)
                
            }
            
            global = cell
            
        }
        
        return global
    }
    
    
}

extension TextViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //改變textView高度
        let frame = textView.frame
        
        let constrainSize = CGSize(width:frame.size.width, height: CGFloat(MAXFLOAT))
        
        let size = textView.sizeThatFits(constrainSize)
        
        textView.frame.size.height = size.height
        
        //拿到現在這個textView的Cell
        guard let cell = textView.superview?.superview as? TextViewTableViewCell else { return true }
        
        //拿其他visible cell
        let visibleCells = tableView.visibleCells
        
        guard let indexPath = tableView.indexPath(for: cell) else { return true }
        
        if cell.frame.size.height < textView.frame.size.height {
            
            //其他visible cell所要增加Y位置的幅度
            let diff = textView.frame.size.height - cell.frame.size.height
            
            //改變現在這個textView的Cell的高度
            cell.frame.size.height = textView.frame.size.height
            
            //改變其他visible cell的高度
            for order in 1..<visibleCells.count {
                            
                if visibleCells[order] != cell && order > indexPath.row {
                    
                    visibleCells[order].frame.origin.y = visibleCells[order].frame.origin.y + diff
                    
                }
                
            }
            
        }
        
        return true
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        //Pass TextView indexPath row for inserting image cell into correct position
        guard let cell = textView.superview?.superview as? TextViewTableViewCell else { return }
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        currentIndexPath = indexPath
        
    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard let cell = textView.superview?.superview as? TextViewTableViewCell else { return }
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        content[indexPath.row] = NewPostTextView(text: textView.text)
        
    }
    
}

extension TextViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
        // 取得從 UIImagePickerController 選擇的檔案
        if let pickedImage = info[.originalImage] as? UIImage {
            
            let newPostImage = NewPostImage(image: pickedImage)
            
            content.insert(newPostImage, at: currentIndexPath.row + 1)
            
            if content.last is NewPostImage {
                
                content.append(NewPostTextView(text: ""))
                
            }
            
            tableView.reloadData()
            
        }
                        
        dismiss(animated: true, completion: nil)
        
    }
}
