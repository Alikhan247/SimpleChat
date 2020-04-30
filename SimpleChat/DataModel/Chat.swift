//
//  Chat.swift
//  SimpleChat
//
//  Created by Alikhan Nursapayev on 4/13/20.
//  Copyright © 2020 Alikhan Nursapayev. All rights reserved.
//

import Foundation
import RealmSwift


class Chat: Object {
    @objc dynamic var uid: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var date: Date?
    var participants = List<String>()
    let messages = List<Message>()
    var parenChat = LinkingObjects(fromType: User.self, property: "chats")
}
