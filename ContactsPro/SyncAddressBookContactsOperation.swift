//
//  SyncContactsWithAddressBookOperation.swift
//  ContactsPro
//
//  Created by Dmitry Shmidt on 16/02/15.
//  Copyright (c) 2015 Dmitry Shmidt. All rights reserved.
//

import UIKit

import AddressBook
import AddressBookUI

import RealmSwift

class SyncAddressBookContactsOperation: NSOperation {
    
    var adbk: ABAddressBook!
    
    override func main() {
        println("main")
        
        if self.cancelled {
            return
        }
        
        if !self.determineStatus() {
            println("not authorized")
            return
        }
        
        importContacts()
        
        if self.cancelled {
            return
        }
    }
    
    var lastSyncDate:NSDate?{
        get{
            return NSUserDefaults.standardUserDefaults().objectForKey("modifiedDate") as? NSDate
        }
        set{
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey:"modifiedDate")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func importContacts(){     
        let realm = Realm()
        realm.beginWrite()
   
        let allPeople = ABAddressBookCopyArrayOfAllPeople(
            adbk).takeRetainedValue() as NSArray

        
        if let lastSyncDate = lastSyncDate{
            //Not first sync
            let deleted = findDeletedPersons(inRealm: realm)
            println("Deleted: \(deleted.count)")
            for person in deleted{
                person.deleteWithChildren(inRealm: realm)
            }

            for personRec: ABRecordRef in allPeople{
                let recordId = ABRecordGetRecordID(personRec)
                
                let queryRecordID = realm.objects(Person).filter("recordID == \(recordId)")
                let foundRecID = queryRecordID.first
                if let foundRecID = foundRecID{
                    if Int(recordId) == foundRecID.recordID{
                        println("Existing person in AB.")
                        foundRecID.updateIfNeeded(fromRecord: personRec, inRealm: realm)
                    }
                }else{
                    println("New person was created in AB, let's add it too.")
                    let newPerson = Person()
                    newPerson.update(fromRecord: personRec, inRealm: realm)
                    realm.add(newPerson)
                }
            }
        }else{
            println("First sync with AB. Add all contacts.")
            for personRec: ABRecordRef in allPeople{
                //First sync
                
                let newPerson = Person()
                newPerson.update(fromRecord: personRec, inRealm: realm)
                realm.add(newPerson)
            }
        }
        realm.commitWrite()
        
        lastSyncDate = NSDate()
    }
    
    func findDeletedPersons(inRealm realm:Realm) -> [Person]{
        let realm = Realm()

        var allRecordsIds = [Int]()
        let allPeople = ABAddressBookCopyArrayOfAllPeople(
            adbk).takeRetainedValue() as NSArray
        for personRec: ABRecordRef in allPeople{
            let recordId = ABRecordGetRecordID(personRec)
            allRecordsIds.append(Int(recordId))
        }
        let allPersons = realm.objects(Person)
        var missingPersons = [Person]()
        
        for person in allPersons{
            let isPersonFound = allRecordsIds.filter { $0 == person.recordID }.count > 0
            if !isPersonFound{
                let foundPerson: ABRecord? = lookup(person: person) as ABRecord?
                if  foundPerson == nil{
                    missingPersons.append(person)
                }
            }
        }

        println("Missing Persons in AB sync: \(missingPersons)")
        return missingPersons
    }
    
    func lookup(#person:Person!) -> ABRecord?{
        var rec : ABRecord! = nil
        let people = ABAddressBookCopyPeopleWithName(self.adbk, person.fullName).takeRetainedValue() as NSArray
        
        for personRec in people {
            if let createdDate = ABRecordCopyValue(personRec, kABPersonCreationDateProperty).takeRetainedValue() as? NSDate {
                if createdDate == person.createdDate {
                    let recordId = ABRecordGetRecordID(personRec)
                    person.recordID == Int(recordId)
                    rec = personRec
                    break
                }
            }
        }
        if rec != nil {
            println("found person and updated recordID")
        }
        return rec
    }
    
    func createAddressBook() -> Bool {
        if self.adbk != nil {
            return true
        }
        var err : Unmanaged<CFError>? = nil
        let adbk : ABAddressBook? = ABAddressBookCreateWithOptions(nil, &err).takeRetainedValue()
        if adbk == nil {
            println(err)
            self.adbk = nil
            return false
        }
        self.adbk = adbk
        return true
    }
    
    func determineStatus() -> Bool {
        let status = ABAddressBookGetAuthorizationStatus()
        switch status {
        case .Authorized:
            return self.createAddressBook()
        case .NotDetermined:
            var ok = false
            ABAddressBookRequestAccessWithCompletion(nil) {
                (granted:Bool, err:CFError!) in
                dispatch_async(dispatch_get_main_queue()) {
                    if granted {
                        ok = self.createAddressBook()
                    }
                }
            }
            if ok == true {
                return true
            }
            adbk = nil
            return false
        case .Restricted:
            adbk = nil
            return false
        case .Denied:

            let alert = UIAlertController(title: "Need Authorization", message: "Wouldn't you like to authorize this app to use your Contacts?", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                _ in
                let url = NSURL(string:UIApplicationOpenSettingsURLString)!
                UIApplication.sharedApplication().openURL(url)
            }))
            UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(alert, animated:true, completion:nil)
            adbk = nil
            return false
        }
    }
    
}
