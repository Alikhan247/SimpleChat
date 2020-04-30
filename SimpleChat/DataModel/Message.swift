//
//  Message.swift
//  SimpleChat
//
//  Created by Alikhan Nursapayev on 4/13/20.
//  Copyright © 2020 Alikhan Nursapayev. All rights reserved.
//

import Foundation
import RealmSwift

class Message: Object {
    @objc dynamic var sender: String = ""
    @objc dynamic var body: String = ""
    @objc dynamic var chat_uid: Int = 0
    var parenChat = LinkingObjects(fromType: Chat.self, property: "messages")
}
