//
//  Note.swift
//  PoliceNetwork
//
//  Created by Dmitry Shmidt on 25/12/14.
//  Copyright (c) 2014 Dmitry Shmidt. All rights reserved.
//
import UIKit
import Realm

class Note: RLMObject {
    dynamic var uuid = NSUUID().UUIDString
    
    dynamic var date = NSDate.distantPast() as NSDate
    dynamic var text = ""
    dynamic var isPrivate = true
    
    override class func primaryKey() -> String! {
        return "uuid"
    }
}