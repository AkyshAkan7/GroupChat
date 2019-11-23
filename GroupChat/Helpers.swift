//
//  Helpers.swift
//  GroupChat
//
//  Created by Akan Akysh on 11/23/19.
//  Copyright © 2019 Akysh Akan. All rights reserved.
//

import UIKit

class Helpers {
    
    static func styleButton(_ button: UIButton) {
        button.layer.cornerRadius = 10
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    }
}
