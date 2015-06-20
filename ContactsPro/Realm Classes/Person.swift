import UIKit
import RealmSwift

import CloudKit
import AddressBookUI
// Person model
class Person: Object {
    dynamic var uuid = NSUUID().UUIDString
    dynamic var group: Group?
    dynamic var recordID            = 0
    
    //Fix for Realm date truncated to milliseconds
    dynamic var createdDateInterval: NSTimeInterval            = 0
    dynamic var createdDate: NSDate?{
        get{
            return createdDateInterval == 0 ? nil : NSDate(timeIntervalSince1970: createdDateInterval)
        }
        set(newModifiedDate){
            
            if let date = newModifiedDate{
                createdDateInterval = date.timeIntervalSince1970
            }else {
                createdDateInterval = 0
            }
        }
    }
    
    dynamic var modifiedDateInterval: NSTimeInterval            = 0
    dynamic var modifiedDate: NSDate?{
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
    
    
    dynamic var firstName      = ""
    dynamic var middleName     = ""
    dynamic var lastName       = ""

    dynamic var tag            = 0

    dynamic var isMissing        = false

    dynamic var isOrganization = false
    dynamic var organization   = ""
    dynamic var department     = ""
    dynamic var jobTitle       = ""
    dynamic var note           = ""
    dynamic var nickname       = ""

    dynamic var fullName       = "No name"

    dynamic var maidenName     = ""

    dynamic var birthPlace     = ""
    dynamic var occupation     = ""
    

    dynamic var weight:Double  = 0
    dynamic var height:Double  = 0
    
    //Data
    dynamic var thumbnailData = NSData()
    
    //Relations
    let addresses     = List<Address>()
    let phones        = List<Phone>()
    let emails        = List<Email>()

    //Custom
    let notes        = List<Note>()
    let strongPoints = List<SimpleNote>()
    let weakPoints   = List<SimpleNote>()
    let todos        = List<ToDo>()
    
    func deleteWithChildren(inRealm realm:Realm){

        realm.delete(addresses)
        realm.delete(phones)
        realm.delete(emails)
        realm.delete(notes)
        realm.delete(self)
    }
    
    var detail: String{
        if !note.isEmpty{
            return note
        }
        return " "
    }
    
    var attributedFullName: NSAttributedString {
        let font =  self.fullName != "No name" ? UIFont(name: "HelveticaNeue-Light", size: 17): UIFont(name: "HelveticaNeue-LightItalic", size: 17)
        
        var underlineColor:UIColor!
        var attributes = [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName : font!]
        switch tag{
        case 0:
            attributes[NSUnderlineStyleAttributeName] = NSUnderlineStyle.StyleNone.rawValue
            attributes[NSUnderlineColorAttributeName] = UIColor.clearColor()
            
        case 1:
            attributes[NSUnderlineStyleAttributeName] = NSUnderlineStyle.StyleSingle.rawValue
            attributes[NSUnderlineColorAttributeName] = UIColor.applicationGreenColor()
            
        case 2:
            attributes[NSUnderlineStyleAttributeName] = NSUnderlineStyle.StyleSingle.rawValue
            attributes[NSUnderlineColorAttributeName] = UIColor.applicationYellowColor()
            
        case 3:
            attributes[NSUnderlineStyleAttributeName] = NSUnderlineStyle.StyleSingle.rawValue
            attributes[NSUnderlineColorAttributeName] = UIColor.applicationRedColor()
            
        case 4:
            attributes[NSForegroundColorAttributeName] = UIColor.applicationBlueColor()
        case 5:
            attributes[NSForegroundColorAttributeName] = UIColor.applicationGrayColor()
            attributes[NSStrikethroughStyleAttributeName] = NSUnderlineStyle.StyleSingle.rawValue
            
        default:()
        attributes[NSUnderlineStyleAttributeName] = NSUnderlineStyle.StyleNone.rawValue
        attributes[NSUnderlineColorAttributeName] = UIColor.clearColor()
        }
        
        var fn = NSMutableAttributedString(string:fullName, attributes:attributes)
        
        let boldRange = (fn.string as NSString).rangeOfString(self.lastName)
        
        if boldRange.location != NSNotFound{
            let boldFont = UIFont(name: "Avenir-Medium", size: 17)
            fn.addAttribute(NSFontAttributeName, value: boldFont!, range: boldRange)
        }

        return fn
    }
    
    var thumbnail: UIImage?{
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
    override static func ignoredProperties() -> [String] {
        return ["thumbnail", "createdDate", "modifiedDate", "attributedFullName"]
    }
    override class func primaryKey() -> String? {
        return "uuid"
    }
    
    lazy var title: String = {
        return self.fullName
        }()
    
    lazy var subtitle: String = {
        var s = ""

        if (!self.department.isEmpty) {
            s += "\(self.department) / "
        }
        s += self.jobTitle
        return s
        }()
}

extension Person{
    func updateIfNeeded(fromRecord person: ABRecordRef, inRealm realm:Realm) {
        let lastModifiedDate = ABRecordCopyValue(person,
            kABPersonModificationDateProperty).takeRetainedValue() as? NSDate
        
        if lastModifiedDate > modifiedDate{
            println("Contact was changed externally, we will update it")
            update(fromRecord: person, inRealm: realm)
        }
    }
    
    func update(fromRecord person: ABRecordRef, inRealm realm:Realm) {
        let recordId = ABRecordGetRecordID(person)
        
        if recordId != kABRecordInvalidID {
            self.recordID = Int(recordId)
        }else{
            println("kABRecordInvalidID")
        }

        firstName = ABRecordCopyValue(person,
            kABPersonFirstNameProperty)?.takeRetainedValue() as! String? ?? ""
        lastName = ABRecordCopyValue(person,
            kABPersonLastNameProperty)?.takeRetainedValue() as! String? ?? ""
        middleName = ABRecordCopyValue(person,
            kABPersonMiddleNameProperty)?.takeRetainedValue() as! String? ?? ""
        
        nickname = ABRecordCopyValue(person, kABPersonNicknameProperty)?.takeRetainedValue() as! String? ?? ""
        
        fullName  = ABRecordCopyCompositeName(person)?.takeRetainedValue() as String? ?? ""
        
        note = ABRecordCopyValue(person,
            kABPersonNoteProperty)?.takeRetainedValue() as! String? ?? ""
        
        createdDate = ABRecordCopyValue(person,
            kABPersonCreationDateProperty).takeRetainedValue() as? NSDate
        modifiedDate = ABRecordCopyValue(person,
            kABPersonModificationDateProperty).takeRetainedValue() as? NSDate
        
        
        jobTitle = ABRecordCopyValue(person, kABPersonJobTitleProperty)?.takeRetainedValue() as! String? ?? ""
        organization = ABRecordCopyValue(person, kABPersonOrganizationProperty)?.takeRetainedValue() as! String? ?? ""
        
        let kind = ABRecordCopyValue(person,
            kABPersonFirstNameProperty)?.takeRetainedValue() as? NSNumber ?? (kABPersonKindPerson as NSNumber)
        isOrganization = kind.isEqualToNumber(kABPersonKindOrganization)
        if kind.isEqualToNumber(kABPersonKindPerson) {
            println("is person \(fullName)")
        } else {
            println("is company \(organization)")
        }
        
        department = ABRecordCopyValue(person, kABPersonDepartmentProperty)?.takeRetainedValue() as! String? ?? ""
        
        if ABPersonHasImageData(person) {
            let data = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail).takeRetainedValue()
            thumbnailData = data
        }
        
        readEmails(fromRecord: person, inRealm: realm)
        readPhones(fromRecord: person, inRealm: realm)
        readAddresses(fromRecord: person, inRealm: realm)
    }
    
    func readEmails(fromRecord person: ABRecordRef, inRealm realm: Realm){
        if let emailsRef: ABMultiValueRef = ABRecordCopyValue(person,
            kABPersonEmailProperty)?.takeRetainedValue(){
                
                for counter in 0..<ABMultiValueGetCount(emailsRef){
                    let label = ABMultiValueCopyLabelAtIndex(emailsRef,
                        counter)?.takeRetainedValue() as? String ?? ""
                    let email = ABMultiValueCopyValueAtIndex(emailsRef,
                        counter).takeRetainedValue() as! String
                    println(label)
                    println(email)
                    let emailObj = realm.create(Email.self, value: ["label": label, "email": email])
                    self.emails.append(emailObj)
                }
        }
    }
    
    func readPhones(fromRecord person: ABRecordRef, inRealm realm: Realm){
        
        if let phonesRef: ABMultiValueRef = ABRecordCopyValue(person,
            kABPersonPhoneProperty)?.takeRetainedValue(){
                
                for counter in 0..<ABMultiValueGetCount(phonesRef){
                    let label = ABMultiValueCopyLabelAtIndex(phonesRef,
                        counter)?.takeRetainedValue() as? String ?? ""
                    let phone = ABMultiValueCopyValueAtIndex(phonesRef,
                        counter).takeRetainedValue() as! String
                    //            println(label)
                    //            println(phone)
                    let strippedPhoneNumber = phone.strippedPhoneNumber
                    let phoneObj = realm.create(Phone.self, value: ["label": label, "formattedNumber": phone, "number": strippedPhoneNumber])
                    self.phones.append(phoneObj)
                }
        }
    }
    
    func readAddresses(fromRecord person: ABRecordRef, inRealm realm:Realm){
        
        if let addressesRef: ABMultiValueRef = ABRecordCopyValue(person,
            kABPersonAddressProperty)?.takeRetainedValue(){
                
                for counter in 0..<ABMultiValueGetCount(addressesRef){
                    let dict = ABMultiValueCopyValueAtIndex(addressesRef, counter).takeRetainedValue() as! NSDictionary
                    
                    let street = dict[String(kABPersonAddressStreetKey)] as? String ?? ""
                    let city = dict[String(kABPersonAddressCityKey)] as? String ?? ""
                    let state = dict[String(kABPersonAddressStateKey)] as? String ?? ""
                    let country = dict[String(kABPersonAddressCountryKey)] as? String ?? ""
                    let countryCode = dict[String(kABPersonAddressCountryCodeKey)] as? String ?? ""
                    let zip = dict[String(kABPersonAddressZIPKey)] as? String ?? ""
                    
                    let label = ABMultiValueCopyLabelAtIndex(addressesRef,
                        counter)?.takeRetainedValue() as? String ?? ""
   
                    let addressObj = realm.create(Address.self, value: ["label": label, "street": street, "city": city, "state": state, "country": country, "countryCode": countryCode, "zip": zip])
                    self.addresses.append(addressObj)
                }
        }
    }
}
