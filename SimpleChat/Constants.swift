//
//  Constants.swift
//  SimpleChat
//
//  Created by Alikhan Nursapayev on 4/13/20.
//  Copyright © 2020 Alikhan Nursapayev. All rights reserved.
//

import Foundation

struct K {
    static let appName = "SimpleChat"
    
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    
    static let cellChatListNibName = "ChatCell"
    
    static let registerSegue = "RegisterToChatList"
    static let loginSegue = "LoginToChatList"
    static let chatSegue = "ToChat"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
        
        static let collectionUsers = "users"
        
        static let chatListCollectionName = "chats"
        static let chatListParticipants = "participants"
    }
}
