import UIKit
import Realm
import Foundation

class Photo: RLMObject {
    dynamic var uuid = NSUUID().UUIDString
    dynamic var imageData = NSData()

    override class func primaryKey() -> String! {
        return "uuid"
    }
}
extension Photo{
    var image:UIImage?{
        get{
            return imageData == NSData() ? nil : UIImage(data: imageData)
        }
        set(newImage){
            if let im = newImage{
                imageData = UIImageJPEGRepresentation(im.scale(maxSize: 800), 0.5)
            }else {
                imageData = NSData()
            }
        }
    }
    
    override class func ignoredProperties() -> [AnyObject]! {
        return ["image"]
    }
}