//
//  ViewController.swift
//  Talky
//
//  Created by Deveesh on 23/08/19.
//  Copyright © 2019 MindfireSolutions. All rights reserved.
//

import UIKit
import XMPPFramework

class ViewController: UIViewController {
    
    //MARK: Properties
    var stream:XMPPStream!
    let xmppRosterStorage = XMPPRosterCoreDataStorage()
    var xmppRoster: XMPPRoster!
    // List of all messages(sent and recieved)
    var messages = [ChatMessage]()
    
    // Credentials
    var myUsername = "user1@localhost"
    var recieveruserName = "deveesh@localhost"
    var thisUsersPassword = "12345"
    
    //MARK: IB Outlets
    @IBOutlet weak var messagesTable: UITableView!
    @IBOutlet weak var messageTextView: UITextView!
    
    //MARK: Initialisation
    override func viewDidLoad() {
        super.viewDidLoad()
        setupXMPPStream()
        setupMessagesTableView()
        resetMessageTextView()
        messagesTable.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc func handleTap(){
        messageTextView.resignFirstResponder()
    }
    
    func setupMessagesTableView() {
        messagesTable.tableFooterView = UIView()
    }
    
    func resetMessageTextView() {
        messageTextView.text = ""
    }
    
    func setupXMPPStream() {
        stream = XMPPStream()
        xmppRoster = XMPPRoster(rosterStorage: xmppRosterStorage)
        stream.addDelegate(self, delegateQueue: DispatchQueue.main)
        stream.myJID = XMPPJID(string: myUsername)
        do {
            try stream.connect(withTimeout: 30)
        }
        catch {
            print("error occured in connecting")
        }
        xmppRoster.activate(stream)
    }
    
    //MARK: IB Actions
    @IBAction func sendMessage(_ sender: Any) {
        let messageToSend = messageTextView.text
        if messageToSend?.count == 0 {
            //No message to send
            return
        }
        let senderJID = XMPPJID(string: recieveruserName)
        let msg = XMPPMessage(type: "chat", to: senderJID)
        msg.addBody(messageToSend!)
        messages.append(ChatMessage(messageRec: messageToSend!, messageTypeRec: Constants.messageType.sent))
        messagesTable.reloadData()
        resetMessageTextView()
        stream.send(msg)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cellName = self.messagesTable.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.chatMessageTBCell, for: indexPath) as! ChatMessageTBCell
        cellName.setViewValues(messageObj: ChatMessage(messageRec: messages[index].message, messageTypeRec: messages[index].messageType))
        return cellName
    }
}

//MARK: XMPPStreamDelegate protocol conformance
extension ViewController: XMPPStreamDelegate{
    func xmppStreamWillConnect(_ sender: XMPPStream) {
        print("WILL CONNECT")
    }
    
    func xmppStreamConnectDidTimeout(_ sender: XMPPStream) {
        print("DID TIMEOUT")
    }
    
    func xmppStreamDidConnect(_ sender: XMPPStream) {
        print("CONNECTED")
        do {
            try sender.authenticate(withPassword: thisUsersPassword)
        }
        catch {
            print("catch")
        }
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
        print("DID AUTHENTICATE")
    }
    
    func xmppStream(_ sender: XMPPStream, didNotAuthenticate error: DDXMLElement) {
        print("DID NOT AUTHENTICATE")
    }
    
    func xmppStream(_ sender: XMPPStream, willReceive message: XMPPMessage) -> XMPPMessage? {
        print(message.body!)
        messages.append(ChatMessage(messageRec: message.body!, messageTypeRec: Constants.messageType.recieved))
        messagesTable.reloadData()
        return message
    }
    
    func xmppStream(_ sender: XMPPStream, didReceive presence: XMPPPresence) {
        print(presence)
        let presenceType = presence.type
        let username = sender.myJID?.user
        let presenceFromUser = presence.from?.user
        
        if presenceFromUser != username  {
            if presenceType == "available" {
                print("available")
            }
            else if presenceType == "subscribe" {
                self.xmppRoster.subscribePresence(toUser: presence.from!)
            }
            else {
                print("presence type")
                print(presenceType)
            }
        }
    }
}

