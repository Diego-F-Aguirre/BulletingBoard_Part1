//
//  MessageController.swift
//  BulletinBoard_Part1_Breakdown
//
//  Created by Diego Aguirre on 8/3/16.
//  Copyright © 2016 home. All rights reserved.
//

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
           refresh { (_) in
            
            }
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
            self.messages.append(message)
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
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.messages = records.flatMap { Message(cloudKitRecord: $0) }
                print("Successfully create Message CKRecord")
            })
         
        }
    }
}
