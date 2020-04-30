//
//  ChatListViewController.swift
//  SimpleChat
//
//  Created by Alikhan Nursapayev on 4/13/20.
//  Copyright © 2020 Alikhan Nursapayev. All rights reserved.
//

import UIKit
import Firebase

class ChatListViewController: UIViewController {
    

    @IBOutlet weak var storiesView: UICollectionView!
    
    var chats = [Chat]()
    var stories = [Story]()
    let db = Firestore.firestore()
    let currentUser =  Auth.auth().currentUser?.email
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true  
        tableView.separatorStyle = .none
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.cellChatListNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        storiesView.delegate = self
        storiesView.dataSource = self
        
        storiesView.layer.isHidden = true
        
        storiesView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "storyCell")
        let selfStory = Story()
        selfStory.uid = "self"
        stories.append(selfStory)
    }
    override func viewWillAppear(_ animated: Bool) {
        loadChats()
    }
    func loadChats() {
        chats = []
        let chat = db.collection(K.FStore.chatListCollectionName).order(by: "email").whereField("participants", arrayContains: currentUser)
        chat.getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    if let senderEmail = data["email"] as? String, let participants = data["participants"] as? [String], let uid = data["uid"] as? Int, let name = data["name"] as? String {
                        let newChat = Chat()
                        newChat.uid = uid
                        newChat.email = senderEmail
                        newChat.name = name
                        for participant in participants {
                            newChat.participants.append(participant)
                        }
                        self.chats.append(newChat)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func newChatButton(_ sender: Any) {
        performSegue(withIdentifier: "toNewChatCreation", sender: self)
    }
    
    func imageWith(name: String?) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .lightGray
        nameLabel.textColor = .white
        nameLabel.layer.cornerRadius = 100
        nameLabel.font = UIFont.boldSystemFont(ofSize: 40)
        nameLabel.text = String(name![(name?.startIndex)!])
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
    
}

extension ChatListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as? ChatCell
        let currentChat = chats[indexPath.row]
        
        cell?.label.text = currentChat.email
        cell?.img.image = imageWith(name: currentChat.email)
        cell?.img.layer.cornerRadius = 30
        cell?.img.layer.masksToBounds = true
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  chats.count > 0 {
            performSegue(withIdentifier: "ListToChat", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ListToChat" {
            let destinationVC = segue.destination as! ChatViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedChat = chats[indexPath.row]
            }
        }
    }
    
}
//MARK: - CollectionView Delegate, DataSource, FlowLayout

extension ChatListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storyCell", for: indexPath) as! CollectionViewCell
               cell.layer.borderWidth = 1
               cell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        if stories[indexPath.row].uid == "self" {
            cell.img.image = #imageLiteral(resourceName: "sendIcon")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = 90
        return CGSize(width: w, height: w)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          return 10
      }
    
}
