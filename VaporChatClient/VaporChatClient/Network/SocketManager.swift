//
//  SocketManager.swift
//  VaporChatClient
//
//  Created by Cody on 4/22/20.
//  Copyright © 2020 Servalsoft. All rights reserved.
//

import Foundation
import Starscream

fileprivate let address = "http://localhost:8080/chat/"

enum SocketEvent {
    case connected
    case disconnected
    case receivedData
}

protocol SocketManagerDelegate {
    func didReceiveEvent(_ event: SocketEvent, data: String?)
}

class SocketManager {
    var socket: WebSocket?
    var delegate: SocketManagerDelegate?
    
    static let shared = SocketManager()
    
    func connectWithName(_ name: String) {
        connectToAddress("\(address)\(name)")
    }
    
    private
    func connectToAddress(_ address: String) {
        // fill in
        guard let urlAddress = URL(string: address) else {
            print("Failed to connect")
            return
        }
        
        var request = URLRequest(url: urlAddress)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        
        socket?.delegate = self
        
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
}

extension SocketManager: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(_):
            print("Connected")
            delegate?.didReceiveEvent(.connected, data: nil)
        case .disconnected(_, _):
            print("Disconnected")
            delegate?.didReceiveEvent(.disconnected, data: nil)
        case .text(let text):
            if text == "newmessages" {
                ChatMediator.shared.fetchMessages()
            } else if text == "loginchange" {
                ChatMediator.shared.fetchConnections()
            }
        default:
            print("Ignored")
        }
    }
}
