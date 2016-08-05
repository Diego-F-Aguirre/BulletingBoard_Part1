//
//  MessageController.swift
//  BulletinBoard_Part1_Breakdown
//
//  Created by Diego Aguirre on 8/3/16.
//  Copyright © 2016 home. All rights reserved.
//

// 1. Import CloudKit and UIKit
import Foundation
import UIKit
import CloudKit

public let MessagesControllerDidRefreshNotification = "MessagesControllerDidRefreshNotification"

class MessageController {
    static var  sharedController = MessageController()
    private let cloudKitManager = CloudKitManager()
    
    init() {
        refresh()
    }
    
    private(set) var messages: [Message] = []
        {
        didSet {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let nc = NSNotificationCenter.defaultCenter()
                nc.postNotificationName(MessagesControllerDidRefreshNotification, object: self)
            })
        }
    }
    
    func postNewMessage(message: Message, completion: ((NSError?) -> Void)? = nil) {
        let record = message.cloudKitRecord
        
        cloudKitManager.saveRecord(record) { (error) in
            defer { completion?(error) }
            if let error = error {
                print("Error save \(message) to CloudKit: \(error)")
                return
            }
            self.messages.insert(message, atIndex: 0)
            print("Message successfully appended to array")
        }
    }
    
    func refresh(completion: ((NSError?) -> Void)? = nil) {
        let sortDescriptors = [NSSortDescriptor(key: Message.dateKey, ascending: false)]
        cloudKitManager.fetchRecordsWithType(Message.recordType, sortDescriptors: sortDescriptors) { records, error in
            defer {
                completion?(error)
            }
            
            if let error = error {
                print("Error fetching messages: \(error)")
                return
            }
            
            guard let records = records else { return }
            
            self.messages = records.flatMap { Message(cloudKitRecord: $0) }
            print("Successfully create Message CKRecord")
        }
    }
    
    // 2. Here we're simply going to create a function to subscribe to push notifications
    func subscribeForPushNotifications(completion: ((NSError?) -> Void)? = nil) {
        // We call our cloudKitManager and our subscribe method and pass in that we want to subscribe to Message.recordType
        cloudKitManager.subscribeToCreationOfRecordsWithType(Message.recordType) { (error) in
            // Some simple error handling here
            if let error = error {
                print("Error saving subscription: \(error)")
            } else {
                print("Subscribed to push notifications for new messages")
            }
            // And finally complete with an error if we have one
            completion?(error)
        }
    }
}




























