import UIKit
import RealmSwift
import AddressBook

class Phone: Object {
    dynamic var uuid = NSUUID().UUIDString
    
    dynamic var number = ""
    dynamic var formattedNumber = ""
    dynamic var label = kABHomeLabel as! String
    
    override class func primaryKey() -> String? {
        return "uuid"
    }
}
