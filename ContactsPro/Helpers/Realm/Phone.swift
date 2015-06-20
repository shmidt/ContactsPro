import UIKit
import Realm
import AddressBook

class Phone: RLMObject {
    dynamic var uuid = NSUUID().UUIDString
    
    dynamic var number = ""
    dynamic var formattedNumber = ""
    dynamic var label:String = kABHomeLabel
    
    override class func primaryKey() -> String! {
        return "uuid"
    }
}
