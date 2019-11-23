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

        setupTableView()
        observeMessages()
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("messages2").addDocument(data:
            [
                "senderId": userId,
                "message": messageTextField.text!,
                "date": Date().timeIntervalSince1970
                ] as [String: Any]
        )
        
        messageTextField.text = ""
        
    }
    
    @IBAction func signoutButtonTapped(_ sender: Any) {
        try! Auth.auth().signOut()
    }
    
    func observeMessages() {
        
        
        Firestore.firestore().collection("messages2").addSnapshotListener { snapshot, error in
            
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
                        let name = document["name"] as! String
                        let surname = document["surname"] as! String

                        let message = Message(name: name, surname: surname, timestamp: convertedDate, messageText: messageText)
                        tempMessages.append(message)
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
    
    func convertDate(date: Double) -> String {
        let convertDate = Date(timeIntervalSince1970: date)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        let dateString = dayTimePeriodFormatter.string(from: convertDate)
        
        return dateString
    }
    
}



// MARK: - table view delegate
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
