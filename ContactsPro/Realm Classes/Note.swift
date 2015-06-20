//
//  Note.swift
//
//  Created by Dmitry Shmidt on 25/12/14.
//  Copyright (c) 2014 Dmitry Shmidt. All rights reserved.
//
import UIKit
import RealmSwift

class Note: Object {
    dynamic var uuid = NSUUID().UUIDString
    
    dynamic var date = NSDate()//NSDate.distantPast() as! NSDate
    dynamic var text = ""
    
    override class func primaryKey() -> String? {
        return "uuid"
    }
}