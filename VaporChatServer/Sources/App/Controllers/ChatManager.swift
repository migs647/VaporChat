//
//  ChatManager.swift
//  App
//
//  Created by Cody on 4/22/20.
//

import Vapor

class ChatManager {
    static let shared = ChatManager()
    var users: [String] {
        get {
            // Grab the list of connections
            let keys = Array(ChatSocketManager.shared.connections.keys)
            return keys
        }
    }
    var messages = [Date: Message]()
    
    func addMessageFrom(_ name: String, message: String, date: Date) {
        messages[date] = Message(name: name, message: message, date: date)
        
        // Alert everyone there is a new message
        ChatSocketManager.shared.sendUpdates()
    }
    
    func messagesSince(_ date: Date) -> [Message] {
        let returnMessages = messages.filter { (compareDate, _) -> Bool in
            return compareDate > date
        }
        
        return returnMessages.values.sorted { return $0.date < $1.date }
    }
}
