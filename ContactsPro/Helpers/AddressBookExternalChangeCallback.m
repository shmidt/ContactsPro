//
//  AddressBookExternalChangeCallback.m
//  VIAddressBookKit
//
//  Created by Nils Fischer on 22.10.14.
//  Copyright (c) 2014 viWiD Webdesign & iOS Development. All rights reserved.
//

#import "AddressBookExternalChangeCallback.h"

void addressBookExternalChangeCallback(ABAddressBookRef addressBookRef, CFDictionaryRef info, void *context)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"addressBookExternalChangeCallback");
        NSLog(@"Re-sync");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddressBookDidChangeExternallyNotification" object:(__bridge id)context]; // TODO: use global constant from swift code as notification name
    });
}

void registerExternalChangeCallbackForAddressBook(ABAddressBookRef addressBookRef)
{
    static BOOL registered = false;
    if (!registered) {
        ABAddressBookRegisterExternalChangeCallback(addressBookRef, addressBookExternalChangeCallback, nil);
        registered = true;
    }
}
