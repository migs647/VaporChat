//
//  ChatViewController.swift
//  VaporChatClient
//
//  Created by Cody on 4/22/20.
//  Copyright © 2020 Servalsoft. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView?
    @IBOutlet weak var textField: UITextField?
    @IBOutlet weak var connectedLabel: UILabel?
    
    var username: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Vapor Chat Messages"
        textField?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ChatMediator.shared.registerAsConsumer(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ChatMediator.shared.deregisterAsConsumer(self)
        SocketManager.shared.disconnect()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if let message = textField?.text {
            textField?.text = ""
            ChatMediator.shared.addMessage(message, from: username ?? "<anon>", date: Date())
        }
    }
}

extension ChatViewController: Consumer {
    func didReceiveMessages(messages: [Message]) {
        
        // Build the chat string
        var chatString = ""
        for message in messages {
            chatString.append("\(message.name)\n\(message.message)\n\n")
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.textView?.text = chatString
        }
    }

    func didReceiveConnectionCount(_ connections: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.connectedLabel?.text = "\(connections) connected"
        }
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage(textField)
        textField.resignFirstResponder()
        return true
    }
}
