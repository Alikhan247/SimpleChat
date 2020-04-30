//
//  ChatViewController.swift
//  SimpleChat
//
//  Created by Alikhan Nursapayev on 4/13/20.
//  Copyright © 2020 Alikhan Nursapayev. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var selectedChat: Chat? {
        didSet {
            // whenever the selectedChat changes, reload messages
            if let selectedChat = selectedChat {
                loadMessages()
            }
            navigationController?.title = "selectedChat?.email"
            
        }
    }
    let userDefault = UserDefaults.standard
    var messages = [Message]()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        tableView.dataSource = self
        
        messageTextField.attributedPlaceholder = NSAttributedString(string: "Message", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        messageTextField.borderStyle = .none;
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if let messagBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messagBody,
                K.FStore.dateField: Date().timeIntervalSince1970,
                "chat_uid": selectedChat!.uid
            ]) { (error) in
                if let e = error {
                    print("Could not save data: \(e)")
                } else {
                    print("saved!")
                }
            }
        }
        messageTextField.text = ""
    }
    
    func loadMessages(){
        if Auth.auth().currentUser != nil {
              
            db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).whereField("chat_uid", isEqualTo: selectedChat?.uid)
                .addSnapshotListener() { (querySnapahot, error) in
                if let e = error {
                    print("Problem with retreiving data: \(e)")
                } else {
                    if let snapshotDocuments = querySnapahot?.documents {
                        self.messages = []
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String, let chatUid = data["chat_uid"] as? Int {
                                
                                let newMessage = Message()
                                newMessage.body=messageBody
                                newMessage.sender = messageSender
                                newMessage.chat_uid = chatUid
                                self.messages.append(newMessage)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                        }
                    }
                }
            }
        }
    }
    @IBAction func logoutButtonPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            self.userDefault.set(false, forKey: "usersignedin")
            self.userDefault.synchronize()
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        ImagePickerManager().pickImage(self){ image in
            //here is the image
            let storage = Storage.storage()
            let storageRef = storage.reference()
        }
    }
    
}

extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as? MessageCell
        cell?.label.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell?.leftImage.isHidden = true
            cell?.rightImage.isHidden = false
            cell?.label.textAlignment = .right
            cell?.bubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell?.label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            cell?.leftImage.isHidden = false
            cell?.rightImage.isHidden = true
            cell?.label.textAlignment = .left
            cell?.bubble.backgroundColor = UIColor(named: K.BrandColors.lighBlue)
            cell?.label.textColor = UIColor(named: K.BrandColors.blue)
        }
        
        return cell!
    }
    
    
}

extension ChatViewController: UIImagePickerControllerDelegate {
    
}
