//
//  AppDelegate.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-10.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Set the status bar to white
        application.setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        
        // For notifications
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))
        // types are UIUserNotificationType members
        
        application.applicationIconBadgeNumber = 0
        
        println("DID FINISH LAUNCHING")
        
        // Set the realm SCHEMA here
        // Notice setSchemaVersion is set to 1, this is always set manually. It must be
        // higher than the previous version (oldSchemaVersion) or an RLMException is thrown
//        setSchemaVersion(1, Realm.defaultPath, { migration, oldSchemaVersion in
//            // We haven’t migrated anything yet, so oldSchemaVersion == 0
//            if oldSchemaVersion < 1 {
//                // Nothing to do!
//                // Realm will automatically detect new properties and removed properties
//                // And will update the schema on disk automatically
//            }
//        })
        // now that we have called `setSchemaVersion(_:_:_:)`, opening an outdated
        // Realm will automatically perform the migration and opening the Realm will succeed
        
        return true
    }
    
    // What happens when the user clicks on the notification
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        println("NOTIFICATION PRESSED")
        
        // Resets the badge number to 0 when the user enters the app
        application.applicationIconBadgeNumber = 0
        
        
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
        
        // Sets the badge number to 0 when the user goes into the app.
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        println("QUITTING")
    }


}

