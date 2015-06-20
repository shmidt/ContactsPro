//
//  AppDelegate.swift
//  ContactsPro
//
//  Created by Dmitry Shmidt on 16/02/15.
//  Copyright (c) 2015 Dmitry Shmidt. All rights reserved.
//
import UIKit
import RealmSwift
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Fabric.with([Crashlytics()])

        setupRealmInAppGroup()

        enableRealmEncryption()
        setupAppearance()
        // Override point for customization after application launch.
        return true
    }

    func setupRealmInAppGroup(){
        let directory = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.com.shmidt.ContactsPro")
        
        if directory == nil {
            fatalError("The shared application group container is unavailable. Check your entitlements and provisioning profiles for this target.")
        }else{
            let realmPath = directory!.path!.stringByAppendingPathComponent("db.realm")
            Realm.defaultPath = realmPath
        }
    }
    
    func enableRealmEncryption(){
        // Realms are used to group data together
        let realm = Realm() // Create realm pointing to default file
        
        // Encrypt realm file
        var error: NSError?
        let success = NSFileManager.defaultManager().setAttributes([NSFileProtectionKey: NSFileProtectionComplete],
            ofItemAtPath: Realm().path, error: &error)
        if !success {
            println("encryption attribute was not successfully set on realm file")
            println("error: \(error?.localizedDescription)")
        }
    }
    
    func setupAppearance(){
        window?.tintColor = UIColor(red: 0.095, green: 0.757, blue: 0.997, alpha: 1.000)
        
        let font = UIFont(name: "Avenir-Medium", size: 18.0)
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName:font!]
//        UITabBar.appearance().selectedImageTintColor = UIColor(red: 0.986, green: 0.120, blue: 0.432, alpha: 1.000)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

