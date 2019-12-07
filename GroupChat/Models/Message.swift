//
//  Message.swift
//  GroupChat
//
//  Created by Akan Akysh on 11/23/19.
//  Copyright © 2019 Akysh Akan. All rights reserved.
//

import Foundation



struct Message {
    var name: String
    var surname: String
    var timestamp: String
    var messageText: String
    
    init(name: String, surname: String, timestamp: String, messageText: String) {
        self.name = name
        self.surname = surname
        self.timestamp = timestamp
        self.messageText = messageText
    }
}
