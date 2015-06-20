//
//  Text.swift
//  ContactsPro
//
//  Created by Dmitry Shmidt on 18/04/15.
//  Copyright (c) 2015 Dmitry Shmidt. All rights reserved.
//

import UIKit
import RealmSwift

class SimpleNote: Object {
    dynamic var uuid = NSUUID().UUIDString
    
    dynamic var date = NSDate()//NSDate.distantPast() as! NSDate
    dynamic var text = ""
    
    override class func primaryKey() -> String? {
        return "uuid"
    }
}
