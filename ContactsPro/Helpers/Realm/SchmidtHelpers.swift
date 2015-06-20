//
//  SchmidtHelpers.swift
//
//  Created by Dmitry Shmidt on 30/11/14.
//  Copyright (c) 2014 Dmitry Shmidt. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    func scale(maxSize:Int = 80) -> UIImage?{
        let image = self
        
        let size = CGSizeMake(CGFloat(maxSize), CGFloat(maxSize))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
}
