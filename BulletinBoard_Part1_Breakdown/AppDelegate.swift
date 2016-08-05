//
//  AppDelegate.swift
//  BulletinBoard_Part1_Breakdown
//
//  Created by Diego Aguirre on 8/3/16.
//  Copyright © 2016 home. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 1. First time when the user opens up the app have the user registers to receive notifications
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        return true
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        
        // 2. If the user says yes to receive remote notifications it'll hit this function
        // This is what will tell CloudKit to watch for new messages.
        // Again the cool thing about this is that it will notify us when we're outside our app that we have a new message
        // Another cool thing is that if you have an iWatch you'll automatically receive a notification on your watch too!!!
        UIApplication.sharedApplication().registerForRemoteNotifications()
        MessageController.sharedController.subscribeForPushNotifications()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        // 3. Finally if we do receive a notification let's call our MessageController and refresh with the new message
        MessageController.sharedController.refresh()
    }
}

