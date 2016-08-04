//
//  MessageListViewController.swift
//  BulletinBoard_Part1_Breakdown
//
//  Created by Diego Aguirre on 8/3/16.
//  Copyright © 2016 home. All rights reserved.
//

import UIKit

class MessageListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MessageController.sharedController.refresh { (_) in
            self.tableView.reloadData()
        }
    }
    
    @IBAction func postButtonPressed(sender: AnyObject) {
        guard let messageText = messageTextField.text where messageText.characters.count > 0 else { return }
        
        messageTextField.resignFirstResponder()
        let message = Message(messageText: messageText, date: NSDate())
        MessageController.sharedController.postNewMessage(message)
        self.messageTextField.text = ""
        MessageController.sharedController.refresh { (_) in
            self.tableView.reloadData()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return messageTextField.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageController.sharedController.messages.count
    }
    
    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
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
