//
//  ChatViewModel.swift
//  SimpleChat
//
//  Created by Alikhan Nursapayev on 5/23/20.
//  Copyright © 2020 Alikhan Nursapayev. All rights reserved.
//

import Foundation
import Firebase
import RealmSwift

protocol MessageManagerDelegate {
    func didUpdateMessages(_ chatManager: NewChatManager, chat: Chat)
    func didFailWitherror(error: Error)
}

class ChatViewManager {
    var messages = [Message]()
    let db = Firestore.firestore()
    
    public var delegate: MessageManagerDelegate?
    
    func loadMessages(selectedChat: Chat?){
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
//                        DispatchQueue.main.async {
//                            self.tableView.reloadData()
//                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
//                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
//                        }
                    }
                }
            }
        }
    }
}
