//
//  Message.swift
//  VaporChatClient
//
//  Created by Cody on 4/22/20.
//  Copyright © 2020 Servalsoft. All rights reserved.
//

import Foundation

struct Message: Codable {
    var uuid = UUID().uuidString
    let name: String
    let message: String
    let date: Date
}
