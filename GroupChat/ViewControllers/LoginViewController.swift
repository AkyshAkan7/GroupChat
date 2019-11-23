//
//  LoginViewController.swift
//  GroupChat
//
//  Created by Akan Akysh on 11/22/19.
//  Copyright © 2019 Akysh Akan. All rights reserved.
//

import UIKit
import FirebaseAuth
import MBProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        Helpers.styleButton(loginButton)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        let activityIndicator = MBProgressHUD.showAdded(to: view, animated: true)
        activityIndicator.label.text = "Login..."
        activityIndicator.backgroundView.color = .lightGray
        activityIndicator.backgroundView.alpha = 0.5
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                activityIndicator.hide(animated: true)
                print(error!.localizedDescription)
                return
            }
            
            activityIndicator.hide(animated: true)
            self.transition()
        }
    }
    
    func transition() {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "mainNavigationVC") as! UINavigationController
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
    }

}
