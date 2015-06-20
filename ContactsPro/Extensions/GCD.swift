//
//  GCD.swift
//  ContactsPro
//
//  Created by Dmitry Shmidt on 20/04/15.
//  Copyright (c) 2015 Dmitry Shmidt. All rights reserved.
//

import Foundation
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}