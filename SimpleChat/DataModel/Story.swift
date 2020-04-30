//
//  Story.swift
//  SimpleChat
//
//  Created by Alikhan Nursapayev on 4/26/20.
//  Copyright © 2020 Alikhan Nursapayev. All rights reserved.
//

import Foundation

import Foundation
import RealmSwift

class Story: Object {
    @objc dynamic var uid: String = ""
    @objc dynamic var img: String = ""
    @objc dynamic var date: Date?
}
