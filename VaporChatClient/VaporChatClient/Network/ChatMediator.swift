//
//  ChatMediator.swift
//  VaporChatClient
//
//  Created by Cody on 4/22/20.
//  Copyright © 2020 Servalsoft. All rights reserved.
//

import Foundation

fileprivate let restAddMessage = "http://localhost:8080/api/addmessage"
fileprivate let restCheckMessages = "http://localhost:8080/api/checkmessages"
fileprivate let restCheckConnections = "http://localhost:8080/api/checkconnections"

protocol Consumer: class {
    func didReceiveMessages(messages: [Message])
    func didReceiveConnectionCount(_ connections: Int)
}

class ChatMediator {
    
    private var consumers = [Consumer]()
    
    static let shared = ChatMediator()
    
    private var messages = [Date: Message]()
    private var dateLastChecked: Date?
    
    func addMessage(_ messageString: String, from: String, date: Date) {
        
        // Create the message to send
        let message = Message(name: from, message: messageString, date: date)
        
        if let url = URL(string: restAddMessage) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            do {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                let encodedMessage = try encoder.encode(message)
                request.httpBody = encodedMessage
            } catch {
                return
            }

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Received a response
                if response != nil {
                    print("Sent message received")
                }
            }
            
            task.resume()
        }
    }
    
    func fetchMessages() {
        if dateLastChecked == nil {
            dateLastChecked = Date(timeIntervalSince1970: 0)
        }
        
        if let dateLastChecked = dateLastChecked {
            let dateFormatter = DateFormatter()

            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

            let dateLastCheckedString = dateFormatter.string(from: dateLastChecked)
            
            let builtURLDateString = "\(restCheckMessages)/\(dateLastCheckedString)"
            guard let url = URL(string: builtURLDateString) else {
                print("Could not create url")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                if let data = data, error == nil {
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let realResponse = try decoder.decode([Message].self, from: data)
                        self?.notifyConsumersOfMessages(realResponse)
                        
                        
                    } catch {
                        print("Could not parse response: \(error.localizedDescription)")
                    }
                }
            }
            task.resume()
        }
    }
    
    func fetchConnections() {
        guard let url = URL(string: restCheckConnections) else {
            print("Could not create url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            if let data = data, error == nil {
                do {
                    let realResponse = try JSONDecoder().decode(Dictionary<String, Int>.self, from: data)
                    if let connectionCount = realResponse["connections"] {
                        self?.notifiyConsumersOfConnections(connectionCount)
                    }
                } catch {
                    print("Could not parse response: \(error.localizedDescription)")
                }
            }
        }
        task.resume()

    }
    
    func registerAsConsumer(_ consumer: Consumer) {
        consumers.append(consumer)
    }
    
    func deregisterAsConsumer(_ consumer: Consumer) {
        consumers.removeAll { (testConsumer) -> Bool in
            testConsumer === consumer
        }
    }
    
    func notifyConsumersOfMessages(_ messages: [Message]) {
        for consumer in consumers {
            consumer.didReceiveMessages(messages: messages)
        }
    }
    
    func notifiyConsumersOfConnections(_ connections: Int) {
        for consumer in consumers {
            consumer.didReceiveConnectionCount(connections)
        }
    }
}
