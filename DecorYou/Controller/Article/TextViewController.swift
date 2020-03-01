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

    @IBOutlet weak var textView: UITextView!
    weak var delegate: TextViewControllerDelegate?
    var content: String = ""
    
    func setTextView() {
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.delegate = self
    }
    
    /*
    func putImg(inputImg: UIImage) {
        
        let attachment = NSTextAttachment()
        
        //將附件的圖片屬性設定為需要插入的圖片,並將附件轉化為屬性化文字,並設定附件的大小
        //設定附件的照片
        attachment.image = inputImg
        
        //調整圖片大小，讓圖片等比例縮放到符合螢幕寬
        let oldWidth = inputImg.size.width
        let scaleFactor = (textView.frame.size.width - 10) / oldWidth
        let newSize = CGSize(width: view.frame.width - 10, height: scaleFactor * inputImg.size.height)
        
        //設定附件的大小(-4這個數字可以根據實際情況除錯,寬高也可以自己設定,這裡用字型大小做參照)
        attachment.bounds = CGRect(origin: CGPoint(x: 0, y: -20), size: newSize)
        
        //將附件轉成NSAttributedString型別的屬性化文字
        let attStr = NSAttributedString(attachment: attachment)
        
        //獲取目前textView中的文字,轉成可變的文字,記錄游標的位置,並插入上一步中的屬性化的文字
        //獲取textView的所有文字,轉成可變的文字
        let mutableStr = NSMutableAttributedString(attributedString: textView.attributedText)
        
        //獲得目前游標的位置
        let selectedRange = textView.selectedRange
        
        //插入文字
        mutableStr.insert(attStr, at: selectedRange.location)
        
        //設定新的可變文字的屬性,並計算新的游標位置
        //設定可變文字的字型屬性
        mutableStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: NSMakeRange(0, mutableStr.length))
        //再次記住新的游標的位置
        let newSelectedRange = NSMakeRange(selectedRange.location + 1, 60)
        
        //將新文字賦值給textView,並恢復游標的位置
        //重新給文字賦值
        textView.attributedText = mutableStr
        //恢復游標的位置(上面一句程式碼執行之後,游標會移到最後面)
        textView.selectedRange = newSelectedRange
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextView()
        textView.text = "請先選擇主題，再編輯內容"
        // Do any additional setup after loading the view.
    }

}

extension TextViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        content = textView.text
        delegate?.passToCreateVC(self)
    }
    
}
