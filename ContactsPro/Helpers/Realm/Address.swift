import UIKit
import Foundation
import AddressBook

class Address: Location {

    dynamic var label:String = kABHomeLabel

//    dynamic var location = Location()
    var criminal: Person? {
        // Inverse relationship
        return (linkingObjectsOfClass(Person.className(), forProperty: "addresses") as [Person]).first
    }
}
