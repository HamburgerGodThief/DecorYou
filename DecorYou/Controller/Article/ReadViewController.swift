//
//  ReadViewController.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/29.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

struct HTMLTest: Codable {
    
    let htmlURL: String
    
}

class ReadViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    func load(completion: @escaping (Result<HTMLTest, Error>) -> Void) {
        ArticleManager.shared.db.collection("test").document("newPostID").getDocument(completion: {
            (document, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let document = document else { return }
                do {
                    if let article = try document.data(as: HTMLTest.self, decoder: Firestore.Decoder()) {
                        completion(.success(article))
                    }
                } catch {
                    print(error)
                    return
                }
            }
            
        })
    }
    
    func setTextView() {
        load(completion: { result in
            switch result {
            case.success(let html):
                let url = URL(string: html.htmlURL)
                if let data = try? Data(contentsOf: url!) {
                    let attribute = NSMutableAttributedString(attributedString: NSKeyedUnarchiver.unarchiveObject(with: data) as! NSAttributedString)
                    
                    //枚舉出富文字中所有的內容
                    attribute.enumerateAttributes(in: NSRange(location: 0, length: attribute.length), options: [], using: { (data, range, _) in
                        
                        //找出富文字中的附件
                        if let attachment = data[.attachment] as? NSTextAttachment {
                            
//                            //取出附件中的圖片
//                            let image = (attachment.image)!
//
//                            //縮放
//                            let scale = (textView.frame.width - 2 * 5 ) / image.size.width
//
//                            //設定大小
//                            attachment.bounds = CGRect(x: 0, y: 0, width: image.size.width * scale, height: image.size.height * scale)
//
//                            //替換富文字中的附件
//                            attribute.replaceCharacters(in: range, with: NSAttributedString(attachment: attachment))
                            
                        }
                        
                    })
                    self.textView.attributedText = attribute
                }
                
            case.failure(let error):
                print(error)
            }
        })
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
