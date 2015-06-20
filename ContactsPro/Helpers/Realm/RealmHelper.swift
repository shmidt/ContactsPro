//
//  RealmHelper.swift
//
//  Created by Dmitry Shmidt on 28/11/14.
//  Copyright (c) 2014 Dmitry Shmidt. All rights reserved.
//

import Foundation
import RealmSwift
import CloudKit

//let schedules = Schedule.allObjects()
//var uniqueIDs = [String]()
//var uniqueSchedules = [Schedule]()
//for schedule in schedules {
//    let schedule = schedule as Schedule
//    let scheduleID = schedule.areas.id
//    if !contains(uniqueIDs, scheduleID) {
//        uniqueSchedules.append(schedule)
//        uniqueIDs.append(scheduleID)
//    }
//}
//println(uniqueSchedules) // Schedule objects with unique `areas.id` values

//extension RLMObject{
//    var record
//    class func create(#record:CKRecord){
//        let realm = RLMRealm.defaultRealm()
//        realm.beginWriteTransaction()
//        
//        let p = self.createInRealm(realm, withObject: ["record": record]) // 💣💥
//        
//        realm.commitWriteTransaction()
//    }
//}