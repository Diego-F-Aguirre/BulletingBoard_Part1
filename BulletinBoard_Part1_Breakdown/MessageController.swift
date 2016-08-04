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

// 9. The public name of the notification to be used anywhere to post the notification and listen to it
public let MessagesControllerDidRefreshNotification = "MessagesControllerDidRefreshNotification"

class MessageController {
    // 2. create a sharedController/singleton
    static var  sharedController = MessageController()
    // 3. create an instance of the CloudKitManager
    private let cloudKitManager = CloudKitManager()
    
    // 10. Finally we want to create an initializer and upon calling MessageController in our other classes we want to fire off 'refresh'
    init() {
        refresh()
    }
    
    // 4. create a private(set) array of Message
    // Note the private(set) syntax. This basically means that this computed property's setter is private to this class only and can only be set here in the MessagesController but it can be public read elswhere in the project
    private(set) var messages: [Message] = []
        {
        // 8. Let's add a didSet to our messages by making messages a computed property
        // In our didSet we're going to implement NSNotification center to alert whoever's listening that are messages has been updated
        // Note that we want to put the notification on the main queue once it get's udpated.
        didSet {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // To post notifications is simple, call NSNotificationCenter which starts broadcasting signals. DefaultCenter is what's used for system notifications
                let nc = NSNotificationCenter.defaultCenter()
                // Note to post a notficiation we're going to have to give it a name. This same name is the name we're going to listen to in the MessageListViewController
                // Since we don't want to be typing this message name key out all the time let's create a public constant abov our MessageController. See step 9 above.
                nc.postNotificationName(MessagesControllerDidRefreshNotification, object: self)
            })
        }
    }
    
    // 5. The first function we'll create is to Post/create new Messages with an optional completion
    func postNewMessage(message: Message, completion: ((NSError?) -> Void)? = nil) {
        // We start of by initializing a CKRecord from our model, remember that computed variable called cloudKitRecord? That's what we're calling here
        let record = message.cloudKitRecord
        
        // We then call our cloudKitManager and save the record
        cloudKitManager.saveRecord(record) { (error) in
            // We could defer the completion here to complete with an error
            defer { completion?(error) }
            // Check if we have an error and if so print out the error
            if let error = error {
                print("Error save \(message) to CloudKit: \(error)")
                return
            }
            // call the messages computed array and append message to it
            self.messages.insert(message, atIndex: 0)
            print("Message successfully appended to array")
        }
    }
    
    // 7. This function we'll create to refresh our CKRecords fetch to see if any new ones were added
    func refresh(completion: ((NSError?) -> Void)? = nil) {
        // We'll start off creating a sortDescriptor based on the Message.dateKey
        let sortDescriptors = [NSSortDescriptor(key: Message.dateKey, ascending: false)]
        // Then we'll call ou cloudKitManager and fetch our records using the recordType for our Message and pass in the sortDescriptor we created
        cloudKitManager.fetchRecordsWithType(Message.recordType, sortDescriptors: sortDescriptors) { records, error in
            // We could create a defer and complete with an error
            defer {
                completion?(error)
            }
            
            if let error = error {
                print("Error fetching messages: \(error)")
                return
            }
            
            guard let records = records else { return }
            
            // If everything goes well we'll set our messages property in the MessageController class to the records array which we flatmap to create Message's out of
            self.messages = records.flatMap { Message(cloudKitRecord: $0) }
            print("Successfully create Message CKRecord")
        }
    }
}
