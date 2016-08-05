//
//  CloudKitManager.swift
//  BulletinBoard_Part1_Breakdown
//
//  Created by Diego Aguirre on 8/3/16.
//  Copyright © 2016 home. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class CloudKitManager {
    let database = CKContainer.defaultContainer().publicCloudDatabase
    
    func fetchRecordsWithType(type: String, sortDescriptors: [NSSortDescriptor]? = nil, completion: ([CKRecord]?, NSError?) -> Void) {
        let query = CKQuery(recordType: type, predicate: NSPredicate(value: true))
        query.sortDescriptors = sortDescriptors
        database.performQuery(query, inZoneWithID: nil, completionHandler: completion)
    }
    
    func saveRecord(record: CKRecord, completion: ((NSError?) -> Void) = {_ in }) {
        database.saveRecord(record) { (_, error) in
            completion(error)
        }
    }
    
    // 1. This function creates a subscription to keep track of newly created records
    // Remember that CKSubscriptions keeps track on the server of changes done to the records
    // To get a CKRecord we're going to need to pass in the type and finally complete with an NSError? This completion is going to be set to optional and nil for it's default value
    func subscribeToCreationOfRecordsWithType(type: String, completion: ((NSError?) -> Void)? = nil) {
        // Here we're creating the subscription from scratch
        let subscription = CKSubscription(recordType: Message.recordType, predicate: NSPredicate(value: true), options: .FiresOnRecordCreation)
        // The CKNotificationInfo is what will actually show the visual alert to the user.
        // Very similar to a UIAlertController
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertBody = "There's a new message on the bulletin board."
        notificationInfo.soundName = UILocalNotificationDefaultSoundName
        // call the method notificaitonInfo on the CKSubscription and set it to the initialized notificationInfo that we created
        subscription.notificationInfo = notificationInfo
        // Finally call the database and call the method on it saveSubscrition to save the subscription we created
        // In the completion we're only going to use the error so let's check if it exist if so print an error statement and finally completes with the error
        database.saveSubscription(subscription) { (subscription, error) in
            if let error = error {
                NSLog("Error saving subscription: \(error)")
            }
            completion?(error)
        }
    }
}
