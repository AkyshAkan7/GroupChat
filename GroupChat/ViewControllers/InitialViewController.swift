//
//  ViewController.swift
//  GroupChat
//
//  Created by Akan Akysh on 11/22/19.
//  Copyright © 2019 Akysh Akan. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        Helpers.styleButton(loginButton)
        Helpers.styleButton(signupButton)
    }

}

