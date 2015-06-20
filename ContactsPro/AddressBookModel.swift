//
//  AddressBookModel.swift
//  ContactsPro
//
//  Created by Dmitry Shmidt on 05/03/15.
//  Copyright (c) 2015 Dmitry Shmidt. All rights reserved.
//

import UIKit
import RealmSwift

import AddressBook
import AddressBookUI

class AddressBookModel: NSObject {

    var adbk: ABAddressBook!
    lazy var queue = NSOperationQueue()
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "determineStatus", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "synchronize", name: "AddressBookDidChangeExternallyNotification", object: nil)
    }
    
    private func createAddressBook() -> Bool {
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
            ABAddressBookRequestAccessWithCompletion(nil) {[unowned self]
                (granted:Bool, err:CFError!) in
                dispatch_async(dispatch_get_main_queue()) {
                    if granted {
                        ok = self.createAddressBook()
                        // Register external change callback
                        registerExternalChangeCallbackForAddressBook(self.adbk)
                        self.synchronize()
                    }
                }
            }
            if ok == true {
                return true
            }
            self.adbk = nil
            return false
        case .Restricted:
            self.adbk = nil
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
            self.adbk = nil
            return false
        }
    }
    
    func synchronize() {
        if !self.determineStatus() {
            println("not authorized")
            return
        }
        let op = SyncAddressBookContactsOperation()
        queue.addOperation(op)
    }
}
