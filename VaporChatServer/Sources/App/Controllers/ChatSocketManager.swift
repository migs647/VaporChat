//
//  ChatSocketManager.swift
//  App
//
//  Created by Cody on 4/22/20.
//

import Vapor

class ChatSocketManager {
    var connections = [String: WebSocket]()
    
    static let shared = ChatSocketManager()
    
    func addConnection(_ socket: WebSocket, forName: String) {
        connections[forName] = socket
        sendLoginChange()
        sendUpdates()
    }
    
    func removeConnection(forName: String) {
        connections.removeValue(forKey: forName)
    }
    
    func sendUpdates() {
        for (_, socket) in connections {
            socket.send("newmessages")
        }
    }
    
    func sendLoginChange() {
        for (_, socket) in connections {
            socket.send("loginchange")
        }
    }
}
