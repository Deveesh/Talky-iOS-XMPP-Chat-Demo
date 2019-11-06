//
//  ChatMessage.swift
//  Talky
//
//  Created by Deveesh on 23/08/19.
//  Copyright © 2019 MindfireSolutions. All rights reserved.
//

import Foundation
class ChatMessage {
    var message: String
    var messageType: Constants.messageType
    
    init(messageRec: String, messageTypeRec: Constants.messageType) {
        self.message = messageRec
        self.messageType = messageTypeRec
    }
}
