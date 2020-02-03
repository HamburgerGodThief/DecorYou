//
//  ChatRoomBottomView.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/3.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class ChatRoomBottomView: UIView {
    
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var albumBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    
    func setElement() {
        cameraBtn.setImage(UIImage.asset(.Icons_24px_Settings), for: .normal)
        cameraBtn.setTitle("", for: .normal)
        albumBtn.setImage(UIImage.asset(.Icons_24px_Settings), for: .normal)
        albumBtn.setTitle("", for: .normal)
        sendBtn.setImage(UIImage.asset(.Icons_24px_Settings), for: .normal)
        sendBtn.setTitle("", for: .normal)
        messageTextView.layer.cornerRadius = 10
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setElement()
        // Initialization code
    }
    
}
