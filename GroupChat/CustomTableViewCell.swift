//
//  CustomTableViewCell.swift
//  GroupChat
//
//  Created by Akan Akysh on 11/23/19.
//  Copyright © 2019 Akysh Akan. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(message: Message) {
        
        usernameLabel.text = message.name + " " + message.surname
        timeLabel.text = message.timestamp
        messageLabel.text = message.messageText
        
        
    }
    
}
