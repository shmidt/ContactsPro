import UIKit
import Realm
import CloudKit
import AddressBookUI
// Person model
class Person: RLMObject {
    dynamic var uuid = NSUUID().UUIDString
    dynamic var group: Group?
    dynamic var recordID            = 0
    
//    dynamic var modifiedDate = NSDate.distantPast() as NSDate//(timeIntervalSince1970: 1)//
    
    dynamic var modifiedDateInterval:NSTimeInterval            = 0
    dynamic var modifiedDate:NSDate?{
        get{
            return modifiedDateInterval == 0 ? nil : NSDate(timeIntervalSince1970: modifiedDateInterval)
        }
        set(newModifiedDate){
            
            if let date = newModifiedDate{
                modifiedDateInterval = date.timeIntervalSince1970
            }else {
                modifiedDateInterval = 0
            }
        }
    }
    
    dynamic var firstName     = ""
    dynamic var middleName    = ""
    dynamic var lastName      = ""

    dynamic var missing       = false

    dynamic var company       = ""
    dynamic var department    = ""
    dynamic var jobTitle      = ""

    dynamic var fullName      = "No name"

    dynamic var maidenName    = ""

    dynamic var birthPlace    = ""
    dynamic var occupation    = ""


    dynamic var weight:Double = 0
    dynamic var height:Double = 0

    //Data
    dynamic var thumbnailData = NSData()

    //Relations
    dynamic var addresses     = RLMArray(objectClassName: Address.className())
    dynamic var phones        = RLMArray(objectClassName: Phone.className())
    dynamic var emails        = RLMArray(objectClassName: Email.className())
    dynamic var notes         = RLMArray(objectClassName: Note.className())
    dynamic var photos        = RLMArray(objectClassName: Photo.className())
//    dynamic var friends     = RLMArray(objectClassName: Person.className())
    //Computed


    func deleteWithChildren(){
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()

        realm.deleteObjects(addresses)
        realm.deleteObjects(phones)
        realm.deleteObjects(emails)
        realm.deleteObjects(notes)
        realm.deleteObjects(photos)
        realm.deleteObject(self)
        realm.commitWriteTransaction()
    }
    
    
    var attributedFullName: NSAttributedString {
        let font =  self.fullName != "No name" ? UIFont(name: "HelveticaNeue-Light", size: 17): UIFont(name: "HelveticaNeue-LightItalic", size: 17)

        var fn = NSMutableAttributedString(string:fullName, attributes:[NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName : font!])

        let boldRange = (fn.string as NSString).rangeOfString(self.lastName)
        
        if boldRange.location != NSNotFound{
            let boldFont = UIFont(name: "HelveticaNeue-Medium", size: 17)
            fn.addAttribute(NSFontAttributeName, value: boldFont!, range: boldRange)
        }
        
        return fn
    }
    
    func ignoredProperties() -> NSArray {
        let propertiesToIgnore = [attributedFullName]
        return propertiesToIgnore
    }

    dynamic var thumbnail:UIImage?{
        get{
            return thumbnailData == NSData() ? nil : UIImage(data: thumbnailData)
        }
        set(newThumbnail){
            
            if let thumb = newThumbnail{
                thumbnailData = UIImageJPEGRepresentation(thumb.scale(maxSize: 80), 0.5)
            }else {
                thumbnailData = NSData()
            }
            
        }
    }
    override class func ignoredProperties() -> [AnyObject]! {
        return ["thumbnail", "modifiedDate"]
    }
    override class func primaryKey() -> String! {
        return "uuid"
    }
    
    lazy var title: String = {
        return self.fullName
        }()
    
    lazy var subtitle: String = {
        var s = ""
        //if (person.abRecordId > 0) {
        //    s += "(\(person.abRecordId)) "
        //}
        if (!self.department.isEmpty) {
            s += "\(self.department) / "
        }
        s += self.jobTitle
        return s
        }()
//    override var record : CKRecord{
//        didSet{
//            didSet {
//                name = super.record.objectForKey("Name") as String!
//                location = super.record.objectForKey("Location") as CLLocation!
//            }
//
//            if let value = someStoredProperty {
//                super.someStoredProperty = value + 10
//            }
//        }
//  }
//    var record : CKRecord! {
//    }
//    dynamic var recordID: CKRecordID{
//        get {
//            record.recordID
//        }
//    }
//    dynamic var recordName = ""
    
//    func ignoredProperties() -> NSArray {
//        let propertiesToIgnore = [recordID]
//        return propertiesToIgnore
//    }
    //CloudKit
}
extension Person{
    func updateIfNeeded(fromRecord person: ABRecordRef, inRealm realm:RLMRealm) {
        let lastModifiedDate = ABRecordCopyValue(person,
            kABPersonModificationDateProperty).takeRetainedValue() as? NSDate
        
        if lastModifiedDate > modifiedDate{
            println("Contact was changed externally, we will update it")
            update(fromRecord: person, inRealm: realm)
        }
//        if let lastModifiedDate = lastModifiedDate{
//            if let modifiedDate = modifiedDate{
//                if lastModifiedDate > modifiedDate{
//                    
//                }
//            }
//
//        }
    }
    
    func update(fromRecord person: ABRecordRef, inRealm realm:RLMRealm) {
        let recordId = ABRecordGetRecordID(person)
        
        if recordId != kABRecordInvalidID {
            self.recordID = Int(recordId)
        }else{
            println("kABRecordInvalidID")
        }
        
        firstName = ABRecordCopyValue(person,
            kABPersonFirstNameProperty).takeRetainedValue() as String
        lastName = ABRecordCopyValue(person,
            kABPersonLastNameProperty).takeRetainedValue() as String
        
        modifiedDate = ABRecordCopyValue(person,
            kABPersonModificationDateProperty).takeRetainedValue() as? NSDate
        
        fullName  = ABRecordCopyCompositeName(person).takeRetainedValue() as String
        
        jobTitle = ABRecordCopyValue(person, kABPersonJobTitleProperty)?.takeRetainedValue() as String? ?? ""
        self.company = ABRecordCopyValue(person, kABPersonOrganizationProperty)?.takeRetainedValue() as String? ?? ""

        self.department = ABRecordCopyValue(person, kABPersonDepartmentProperty)?.takeRetainedValue() as String? ?? ""
        
        if ABPersonHasImageData(person) {
            let data = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail).takeRetainedValue()
            self.thumbnailData = data
        }
        
        readEmails(fromRecord: person, inRealm: realm)
        readPhones(fromRecord: person, inRealm: realm)
        readAddresses(fromRecord: person, inRealm: realm)
    }
    
    func readEmails(fromRecord person: ABRecordRef, inRealm realm:RLMRealm){
        
        let emails: ABMultiValueRef = ABRecordCopyValue(person,
            kABPersonEmailProperty).takeRetainedValue()

        for counter in 0..<ABMultiValueGetCount(emails){
            let label = ABMultiValueCopyLabelAtIndex(emails,
                counter).takeRetainedValue() as String
            let email = ABMultiValueCopyValueAtIndex(emails,
                counter).takeRetainedValue() as String
            println(label)
            println(email)
            let emailObj = Email.createInRealm(realm, withObject: ["label": label, "email": email])
            self.emails.addObject(emailObj)
        }
    }
    
    func readPhones(fromRecord person: ABRecordRef, inRealm realm:RLMRealm){
        
        let phones: ABMultiValueRef = ABRecordCopyValue(person,
            kABPersonPhoneProperty).takeRetainedValue()

        for counter in 0..<ABMultiValueGetCount(phones){
            let label = ABMultiValueCopyLabelAtIndex(phones,
                counter).takeRetainedValue() as String
            let phone = ABMultiValueCopyValueAtIndex(phones,
                counter).takeRetainedValue() as String
            println(label)
            println(phone)
            let phoneObj = Phone.createInRealm(realm, withObject: ["label": label, "phone": phone])
            self.phones.addObject(phoneObj)
        }
    }
    
    func readAddresses(fromRecord person: ABRecordRef, inRealm realm:RLMRealm){
        
        let addresses: ABMultiValueRef = ABRecordCopyValue(person,
            kABPersonAddressProperty).takeRetainedValue()

        for counter in 0..<ABMultiValueGetCount(addresses){
            let dict = ABMultiValueCopyValueAtIndex(addresses, counter).takeRetainedValue() as NSDictionary
            
            let street = dict[String(kABPersonAddressStreetKey)] as? String ?? ""
            let city = dict[String(kABPersonAddressCityKey)] as? String ?? ""
            let state = dict[String(kABPersonAddressStateKey)] as? String ?? ""
            let country = dict[String(kABPersonAddressCountryKey)] as? String ?? ""
            let countryCode = dict[String(kABPersonAddressCountryCodeKey)] as? String ?? ""
            let zip = dict[String(kABPersonAddressZIPKey)] as? String ?? ""
            
            let label = ABMultiValueCopyLabelAtIndex(addresses,
                counter).takeRetainedValue() as String

            println(label)

            let addressObj = Address.createInRealm(realm, withObject: ["label": label, "street": street, "city": city, "state": state, "country": country, "countryCode": countryCode, "zip": zip])
            self.addresses.addObject(addressObj)
        }
    }
}
