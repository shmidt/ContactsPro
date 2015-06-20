import UIKit
import Foundation
import AddressBook

import RealmSwift

class Address: Location {

    dynamic var label = kABHomeLabel as! String

    var person: Person? {
        // Inverse relationship
        let addresses = linkingObjects(Person.self, forProperty: "addresses")
        return addresses.first
    }
}
