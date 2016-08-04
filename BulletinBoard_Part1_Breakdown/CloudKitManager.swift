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
    // For our use of CloudKit here we're simply going to be using the default container with a public database
    let database = CKContainer.defaultContainer().publicCloudDatabase
    
    // This function simply fetches the records that match a type we're looking for
    func fetchRecordsWithType(type: String, sortDescriptors: [NSSortDescriptor]? = nil, completion: ([CKRecord]?, NSError?) -> Void) {
        // We create a query using CKQuery passing in the type and creatring a NSPredicate who's value is set to true to fetch all the items
        let query = CKQuery(recordType: type, predicate: NSPredicate(value: true))
        // A CKQuery also needs a sort descriptor set at intialization time so we call the sortDescriptors method on the query and set the sortDescriptor function parameter to it
        query.sortDescriptors = sortDescriptors
        // Finally on the database we performQuery to fetch our records
        // We pass the query we created previously and set the inZoneWithID to nil and for the completionHandler we pass in the completion which hopefully is an array of CKRecords
        database.performQuery(query, inZoneWithID: nil, completionHandler: completion)
    }
    
    // This function simply saves a CKRecord to the database
    func saveRecord(record: CKRecord, completion: ((NSError?) -> Void) = {_ in }) {
        // all we do is call the database and saveRecord which is a method available to us on CKDatabase
        // Since we don't need to do anything with the CKRecord in the closure let's nullify it with _
        // Finally since the method has a completion closure of NSError let's complete with an error in case we have one
        database.saveRecord(record) { (_, error) in
            completion(error)
        }
    }
}
