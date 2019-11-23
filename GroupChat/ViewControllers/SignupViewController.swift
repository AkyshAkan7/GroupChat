//
//  SignupViewController.swift
//  GroupChat
//
//  Created by Akan Akysh on 11/22/19.
//  Copyright © 2019 Akysh Akan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MBProgressHUD

class SignupViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        Helpers.styleButton(signupButton)
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        guard let name = nameTextField.text else { return }
        guard let surname = surnameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        let activityIndicator = MBProgressHUD.showAdded(to: view, animated: true)
        activityIndicator.label.text = "Sign up..."
        activityIndicator.backgroundView.color = .lightGray
        activityIndicator.backgroundView.alpha = 0.5
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                activityIndicator.hide(animated: true)
                print(error!.localizedDescription)
                return
            }
            
            Firestore.firestore().collection("users").document(name + " " + surname).setData(
                [
                    "name": name,
                    "surname": surname,
                    "email": email,
                    "id": result!.user.uid
                ])
            
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
