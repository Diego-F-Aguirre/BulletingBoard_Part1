//
//  MessageListViewController.swift
//  BulletinBoard_Part1_Breakdown
//
//  Created by Diego Aguirre on 8/3/16.
//  Copyright © 2016 home. All rights reserved.
//

import UIKit

// 1. Make sure to conform to the appropriate delegates and datasource. We're also going to specifically need to conform to the UITextFieldDelegate
class MessageListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(messagesWereUpdated), name: MessagesControllerDidRefreshNotification, object: nil)
    }
    
    //2 . Let's send a message
    @IBAction func postButtonPressed(sender: AnyObject) {
        // Check if your textfield has text
        guard let messageText = messageTextField.text where messageText.characters.count > 0 else { return }
        // resign the keyboard upon hitting the post button
        messageTextField.resignFirstResponder()
        // Create a Message from the passed in text and today's current date
        let message = Message(messageText: messageText, date: NSDate())
        // Call your postNewMessage func from the MessagesController and pass in your message
        MessageController.sharedController.postNewMessage(message)
        self.messageTextField.text = ""
        
    }
    
    func messagesWereUpdated(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView?.reloadData()
        })
        
    }
    
    // 3. Call the textFieldShouldReturn func and resign the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return messageTextField.resignFirstResponder()
    }
    
    // 4. Fill out our DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageController.sharedController.messages.count
    }
    
    // 4.5 Create a dateFormatter computed property which we'll call for our detailTextLabel
    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        // Have teh students look up what doesRelativeDateFormatting does
        formatter.doesRelativeDateFormatting = true
        formatter.timeStyle = .ShortStyle
        
        return formatter
        
    }()
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath)
        
        let message = MessageController.sharedController.messages[indexPath.row]
        cell.textLabel?.text = message.messageText
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(message.date)
        
        return cell
    }
    
}
