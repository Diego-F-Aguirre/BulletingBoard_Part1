//
//  Message+CloudKit.swift
//  BulletinBoard_Part1_Breakdown
//
//  Created by Diego Aguirre on 8/3/16.
//  Copyright © 2016 home. All rights reserved.
//

import Foundation
import CloudKit

extension Message {
    // 2. Here we're creating the correct keys to use when fetching CKRecords
    // Note: the recordType key is actually the name of the model object so in this instance it's "Message". This is similar concept as the entity name in CoreData
    // Note: because we're in a extension we can't create properties so the workaround is to create a static var computed property that return's the keyname
    static var recordType: String { return "Message" }
    static var messageTextKey: String { return "MessageText" }
    static var dateKey: String { return "Date" }
    
    // 1. Here we're creating a failable initializer for our CKRecord that we hope to receive back from the Apple servers.
    // A CKRecord contains data in a key/value pair... so a CKRecord is literally just a glorified Dictionary. This is stated in the documentation, have the students take a quick look.
    // Like any failable initializer we need to make sure we're matching with the correct key
    init?(cloudKitRecord: CKRecord) {
        // In here we're just making sure we're getting the correct key for our message body
        guard let messageText = cloudKitRecord[Message.messageTextKey] as? String,
            // Every record has a date of when it was first saved to the server, if for some reason this is not the case we're calling the date key our our record.
            date = cloudKitRecord.creationDate ?? cloudKitRecord[Message.dateKey] as? NSDate
            // finally every record has a recordType and here we're making sure we're making sure to get back only the records with the type that match our Message model recordType. As we can have more than one CKRecords each with their own type.
            where cloudKitRecord.recordType == Message.recordType else { return nil }
        
        // finally again since we're in a extenstion we have to call init our self (Message) and initialize the two properties of the model
        self.init(messageText: messageText, date: date)
    }
    
    // 3. This computed var creates a CKRecord itself by initialzing our model as a record
    var cloudKitRecord: CKRecord {
        let record = CKRecord(recordType: Message.recordType)
        record[Message.messageTextKey] = messageText
        record[Message.dateKey] = date
        return record
    }
}
