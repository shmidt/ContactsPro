import UIKit
import Realm
import CoreLocation
import MapKit
import CloudKit
import AddressBook
import AddressBookUI

class Location: RLMObject, MKAnnotation {
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
    dynamic var country:String = Location.currentCountry()
//    dynamic var type:Int       = 0

    dynamic var latitude       = 0.0
    dynamic var longitude      = 0.0

    class func currentCountry() -> String{
        let locale = NSLocale.currentLocale()
        let countryCode = locale.objectForKey(NSLocaleCountryCode) as String
        return locale.displayNameForKey(NSLocaleCountryCode, value: countryCode) ?? ""//"RUSSIA"//TODO:
    }
    
    dynamic var distance: CLLocationDistance = 0
    
    func ignoredProperties() -> NSArray {
        let propertiesToIgnore = [distance]
        return propertiesToIgnore
    }
    
//    func fill(placemark:GooglePlacemark) -> () {
//        name           = placemark.name
////        note           = 
////        aptNo          =
////        floorNo        =
////        entranceNo     =
//        houseNo        = placemark.streetNumber
//        street         = placemark.route
//        city           = placemark.locality
//        province       = placemark.administrativeArea
//        postalCode     = placemark.postalCode
//        country = placemark.country
////
////
////        placemark.subLocality            
////        placemark.formattedAddress       
////
////        placemark.administrativeAreaCode 
////        placemark.subAdministrativeArea  
////
////
////        placemark.ISOcountryCode         
////        placemark.state                  
//        
//    }
    
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
    
    override class func ignoredProperties() -> [AnyObject]! {
        return ["location", "coordinate"]
    }
    override class func primaryKey() -> String! {
        return "uuid"
    }
//    var record : CKRecord! {
//        didSet {
//            name = record.objectForKey("Name") as String!
//            location = record.objectForKey("Location") as CLLocation!
//        }
//    }
//    
//    dynamic var recordID: CKRecordID{
//        get{
//            CKRecordID(recordName: recordName)
//        }
//        set{
//            
//        }
//    }
//    dynamic var recordName = ""
//    dynamic var category = Category()

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

//    // 4
//    let lat = aDecoder.decodeDoubleForKey("latitude")
//    let lon = aDecoder.decodeDoubleForKey("longitude")
//    // 5
//    let decodedLocation = CLLocation(latitude: lat,
//        longitude: lon)
//    self.record.setObject(decodedLocation, forKey: "Location")
//    self.location = decodedLocation
}

//MARK: Equatable

//func == (lhs: Location, rhs: Location) -> Bool {
//    return lhs.record.recordID == rhs.record.recordID
//}
