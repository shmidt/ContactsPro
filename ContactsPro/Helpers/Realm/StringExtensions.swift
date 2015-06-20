//
//  StringExtensions.swift
//  ContactsPro
//
//  Created by Dmitry Shmidt on 17/04/15.
//  Copyright (c) 2015 Dmitry Shmidt. All rights reserved.
//

import Foundation
extension String{
    var strippedPhoneNumber: String{
        return "".join(self.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet))
    }
}