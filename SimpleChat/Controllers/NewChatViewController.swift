//
//  NewChatViewController.swift
//  SimpleChat
//
//  Created by Alikhan Nursapayev on 4/13/20.
//  Copyright © 2020 Alikhan Nursapayev. All rights reserved.
//

import UIKit

class NewChatViewController: UIViewController {
    
    var users = [User]()
       
    var chats = [Chat]()
    
    var givenChat = Chat()
    
    var chatManager = NewChatManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: K.cellChatListNibName, bundle: nil), forCellReuseIdentifier: K.cellNibName)
        tableView.dataSource = self
        tableView.delegate = self
        chatManager.delegate = self
        chatManager.loadUsers()
        chatManager.loadChats()
    }
    
    
    
  
    
}

extension NewChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellNibName, for: indexPath) as? ChatCell
        cell?.label.text = users[indexPath.row].email
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chatManager.createChat(with: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToChat" {
            let destinationVC = segue.destination as! ChatViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
//                print("given \(givenChat)")
                destinationVC.selectedChat = givenChat
            }
        }
    }
}

extension NewChatViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        //        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            //            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

extension NewChatViewController: NewChatManagerDelegate {
    func didUpdateChat(_ chatManager: NewChatManager, chat: Chat) {
        givenChat = chat
        performSegue(withIdentifier: "ToChat", sender: self)
    }
    func didUpdateChatUsers(_ chatManager: NewChatManager, users: [User]) {
        self.users = []
        for i in users {
            self.users.append(i)
        }
        tableView.reloadData()
    }
    func didFailWitherror(error: Error) {
        
    }
    
    
}
