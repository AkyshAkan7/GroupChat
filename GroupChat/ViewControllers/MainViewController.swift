//
//  MainViewController.swift
//  GroupChat
//
//  Created by Akan Akysh on 11/23/19.
//  Copyright © 2019 Akysh Akan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextField.delegate = self

        setupTableView()
        keyboardEvents()
        observeMessages()
    }
    
    deinit {
        // Stop listening for keyboard hide/show events
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        print(Date().timeIntervalSince1970)
        
        if !messageTextField.text!.isEmpty {
            
            Firestore.firestore().collection("messages3").addDocument(data:
                [
                    "senderId": userId,
                    "message": messageTextField.text!,
                    "date": Date().timeIntervalSince1970
                    ] as [String: Any]
            )
            
        }
        
        messageTextField.text = ""
        
    }
    
    @IBAction func signoutButtonTapped(_ sender: Any) {
        try! Auth.auth().signOut()
    }
    
    func observeMessages() {
        
        let ref = Firestore.firestore().collection("messages3")
        
        ref.order(by: "date", descending: false).addSnapshotListener { snapshot, error in
            
            var tempMessages = [Message]()
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            for document in snapshot!.documents {
                let senderId = document["senderId"] as! String
                let messageText = document["message"] as! String
                let date = document["date"] as! Double
                
                let convertedDate = self.convertDate(date: date)
                
                Firestore.firestore().collection("users").whereField("id", isEqualTo: senderId).addSnapshotListener { snapshot, error in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }

                    for document in snapshot!.documents {
                        
                        if senderId == Auth.auth().currentUser?.uid {
                            let name = "I"
                            let surname = ""
                            
                            let message = Message(name: name, surname: surname, timestamp: convertedDate, messageText: messageText)
                            tempMessages.append(message)
                        } else {
                            let name = document["name"] as! String
                            let surname = document["surname"] as! String
                            
                            let message = Message(name: name, surname: surname, timestamp: convertedDate, messageText: messageText)
                            tempMessages.append(message)
                        }
                        
                    }
                    
                    self.messages = tempMessages
                    self.tableView.reloadData()

                }
        
            }
            
        }
    }
    
    func setupTableView() {
        let cellNib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "customCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    // Listen for keyboard events
    func keyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // this function called when keyboard event triggered
    @objc func keyboardWillChange(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            switch notification.name {
            case UIResponder.keyboardWillShowNotification:
                view.frame.origin.y -= keyboardHeight
            case UIResponder.keyboardWillHideNotification:
                view.frame.origin.y = 0
            default:
                return
            }
            
        }
    }
    
    
    // function for convert date
    func convertDate(date: Double) -> String {
        let convertDate = Date(timeIntervalSince1970: date)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        let dateString = dayTimePeriodFormatter.string(from: convertDate)
        
        return dateString
    }
    
}



// MARK: - Table view delegate
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        cell.set(message: messages[indexPath.row])
        return cell
    }
}

// MARK: - text field delegate
extension MainViewController: UITextFieldDelegate {
    
    func hideKeyboard() {
        messageTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        
        return true
    }
    
}
