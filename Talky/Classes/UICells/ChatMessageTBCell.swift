//
//  ChatMessageTBCell.swift
//  Talky
//
//  Created by Deveesh on 23/08/19.
//  Copyright © 2019 MindfireSolutions. All rights reserved.
//

import UIKit

class ChatMessageTBCell: UITableViewCell {
    
    @IBOutlet weak var chatMessage: UILabel!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightMarginConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setViewValues(messageObj: ChatMessage) {
        chatMessage.text = messageObj.message
        if messageObj.messageType == .sent {
            chatMessage.textAlignment = .left
            chatMessage.backgroundColor = .lightGray
            self.removeConstraint(rightMarginConstraint)
        }else {
            chatMessage.textAlignment = .right
            chatMessage.backgroundColor = .green
            self.removeConstraint(leftMarginConstraint)
        }
    }
}
