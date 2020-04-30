//
//  NewChatManager.swift
//  SimpleChat
//
//  Created by Alikhan Nursapayev on 4/19/20.
//  Copyright © 2020 Alikhan Nursapayev. All rights reserved.
//

import Foundation
import Firebase
import RealmSwift

protocol NewChatManagerDelegate {
    func didUpdateChat(_ chatManager: NewChatManager, chat: Chat)
    func didUpdateChatUsers(_ chatManager: NewChatManager, users: [User])
    func didFailWitherror(error: Error)
}

class NewChatManager {
    var users = [User]()
    
    var chats = [Chat]()
    
    var realm = try! Realm()
    
    let db = Firestore.firestore()
    
    public var delegate: NewChatManagerDelegate?
    
    func loadUsers() {
        db.collection(K.FStore.collectionUsers).addSnapshotListener() { (querySnapahot, error) in
            if let e = error {
                print("Problem with retreiving data: \(e)")
                self.delegate?.didFailWitherror(error: e)
            } else {
                if let snapshotDocuments = querySnapahot?.documents {
                    self.users = []
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let email = data["email"] as? String, let uid = data["uid"] as? String {
                            let user = Auth.auth().currentUser
                            if email != user?.email{
                                let newUser = User()
                                newUser.email = email
                                newUser.uid = uid
                                self.users.append(newUser)
                            }
                        }
                    }
                    
                }
                self.delegate?.didUpdateChatUsers(self, users: self.users)
            }
        }
    }
    
    func loadChats() {
        let newChat = Chat()
        let chat = db.collection(K.FStore.chatListCollectionName)
        chat.getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    if let senderEmail = data["email"] as? String, let participants = data["participants"] as? [String], let uid = data["uid"] as? Int {
                        newChat.uid = uid
                        newChat.email = senderEmail
                        for participant in participants {
                            newChat.participants.append(participant)
                        }
                        print("heree")
                        self.chats.append(newChat)
                        
                    }
                    //print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    
    func createChat(with indexPath: IndexPath) {
        let newChat = Chat()
        let randomUID = Int.random(in: 1...9999999999)
        let user = Auth.auth().currentUser
        var found = false
        if chats.count > 0 {
            for currentChat in chats {
                for participant in currentChat.participants {
                    if participant == user?.email {
                        found = true
                        newChat.uid = currentChat.uid
                        newChat.name = currentChat.name
                        newChat.email = currentChat.email
                        newChat.participants.append(currentChat.participants[0])
                        newChat.participants.append(currentChat.participants[1])
                        newChat.date = currentChat.date
                        break
                    }
                }
                
            }
        }
        else {
            newChat.participants.removeAll()
            self.db.collection(K.FStore.chatListCollectionName).addDocument(data: [
                "name": self.users[indexPath.row].name ,
                "email": self.users[indexPath.row].email ,
                "uid": randomUID,
                "participants" : [user?.email, self.users[indexPath.row].email],
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("Could not save data: \(e)")
                } else {
                    print("saved!")
                    newChat.uid = randomUID
                    newChat.name = self.users[indexPath.row].name
                    newChat.email = self.users[indexPath.row].email
                    newChat.participants.append((user?.email)!)
                    newChat.participants.append(self.users[indexPath.row].email)
                    newChat.date = Date()
                    
                    self.delegate?.didUpdateChat(self, chat: newChat)
                }
            }
            //                    self.performSegue(withIdentifier: "ToChat", sender: self)
        }
        if !found {
            newChat.participants.removeAll()
            self.db.collection(K.FStore.chatListCollectionName).addDocument(data: [
                "name": self.users[indexPath.row].name,
                "email": self.users[indexPath.row].email,
                "uid": randomUID,
                "participants" : [user?.email, self.users[indexPath.row].email],
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("Could not save data: \(e)")
                } else {
                    print("saved!")
                    newChat.uid = randomUID
                    newChat.name = self.users[indexPath.row].name
                    newChat.email = self.users[indexPath.row].email
                    newChat.participants.append((user?.email)!)
                    newChat.participants.append(self.users[indexPath.row].email)
                    newChat.date = Date()
                    
                    self.delegate?.didUpdateChat(self, chat: newChat)
                }
            }
            //                    performSegue(withIdentifier: "ToChat", sender: self)
        } else {
            let chat = db.collection(K.FStore.chatListCollectionName)
            chat.getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        
                        if let senderEmail = data["email"] as? String, let participants = data["participants"] as? [String], let uid = data["uid"] as? Int, let name = data["name"] as? String {
                            if senderEmail == self.users[indexPath.row].email {
                                newChat.participants.removeAll()
                                newChat.uid = uid
                                newChat.email = senderEmail
                                newChat.name = name
                                print("sended \(newChat)")
                                for participant in participants {
                                    newChat.participants.append(participant)
                                }
                                break
                            }
                        }
                    }
                    print("I am a \(newChat)")
                    self.delegate?.didUpdateChat(self, chat: newChat)
                }
            }
        }
    }
}
