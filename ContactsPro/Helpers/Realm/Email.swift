//
//  Email.swift
//  ContactsPro
//
//  Created by Dmitry Shmidt on 17/02/15.
//  Copyright (c) 2015 Dmitry Shmidt. All rights reserved.
//

import UIKit
import Realm
import AddressBook

class Email: RLMObject {
    dynamic var uuid = NSUUID().UUIDString
    
    dynamic var email = ""
    dynamic var label:String = kABHomeLabel
    
    override class func primaryKey() -> String! {
        return "uuid"
    }
}
