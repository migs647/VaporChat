//
//  ViewController.swift
//  VaporChatClient
//
//  Created by Cody on 4/22/20.
//  Copyright © 2020 Servalsoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    
    private var chatname: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "VaporChat"
    }
    
    @IBAction func login(_ sender: Any) {
        if let name = nameField.text, !name.isEmpty {
            chatname = name
            // Connect to the socket server
            SocketManager.shared.delegate = self
            SocketManager.shared.connectWithName(name)
        }
    }
}

extension ViewController: SocketManagerDelegate {
    func didReceiveEvent(_ event: SocketEvent, data: String?) {
        if event == .connected {
            // Grab the storyboard id and push
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ChatViewController") as? ChatViewController {
                viewController.username = chatname
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    
}

