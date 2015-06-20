import UIKit

import RealmSwift

import CoreLocation
import MapKit
import CloudKit
import AddressBook
import AddressBookUI

class Location: Object, MKAnnotation {
    dynamic var uuid = NSUUID().UUIDString
    
    dynamic var name           = ""
    dynamic var note           = ""
    dynamic var aptNo          = ""
    dynamic var floorNo        = ""
    dynamic var entranceNo     = ""
    dynamic var houseNo        = ""
    dynamic var street         = ""
    dynamic var city           = ""
    dynamic var province       = ""
    dynamic var postalCode     = ""
    dynamic var country: String = Location.currentCountry()

    dynamic var latitude       = 0.0
    dynamic var longitude      = 0.0

    class func currentCountry() -> String{
        let locale = NSLocale.currentLocale()
        let countryCode = locale.objectForKey(NSLocaleCountryCode) as! String
        return locale.displayNameForKey(NSLocaleCountryCode, value: countryCode) ?? ""
    }
    
    dynamic var distance: CLLocationDistance = 0
    
    var addressDictionary: [String: String]{
        var addressDict = [
            kABPersonAddressStreetKey as String : street,
            kABPersonAddressCityKey as String : city,
            kABPersonAddressStateKey as String : province,
            kABPersonAddressZIPKey as String : postalCode,
            kABPersonAddressCountryKey as String : country
        ]
        return addressDict
    }
    var summary:String{
        get{
            var addr = ""
            if !entranceNo.isEmpty{
                addr += "entrance No." + " " + entranceNo + "\n"
            }
            if !floorNo.isEmpty{
                addr += "floor No." + " " + floorNo + "\n"
            }
            if !aptNo.isEmpty{
                addr += "apt. No." + " " + aptNo + "\n"
            }
            let textValues = [addr, street, city, province, postalCode, country]
            var text = "\n".join(textValues.filter( { $0.isEmpty == false } ).map({ $0 }))
            return text
        }
    }
    var addressString: String{
        get{
           return ABCreateStringWithAddressDictionary(addressDictionary, false)
        }
    }
    dynamic var location:CLLocation{
        get{
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        set(newLocation){
            latitude = newLocation.coordinate.latitude
            longitude = newLocation.coordinate.longitude
        }
    }
    
    override static func ignoredProperties() -> [String] {
        return ["location", "coordinate"]
    }
    override class func primaryKey() -> String? {
        return "uuid"
    }

    //MARK: - map annotation
    
    dynamic var coordinate : CLLocationCoordinate2D {
        get {
            return location.coordinate
        }
        set(newCoordinate){
            latitude = newCoordinate.latitude
            longitude = newCoordinate.longitude
        }
    }
    var title : String! {
        get {
            return name
        }
    }
}
