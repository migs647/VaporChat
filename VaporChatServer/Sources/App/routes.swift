import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "Try Again"
    }
    
    // Add the fetch messages route
    router.get("api/checkmessages", String.parameter) { (request) -> [Message] in
        let dateString = try request.parameters.next(String.self)
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

        if let createdDate = dateFormatter.date(from: dateString) {
            
            // Grab all of the messages since that date
            let messages = ChatManager.shared.messagesSince(createdDate)

            return messages
        } else {
            return [Message]()
        }
    }
    
    router.get("api/checkconnections") { (request) -> String in
        // Grab all of the messages since that date
        let numberOfConnections = ChatManager.shared.users.count

        return "{\"connections\":\(numberOfConnections)}"
    }

    // Add the add message post
    router.post(Message.self, at: "api/addmessage") { (request, data) -> AddMessageResponse in
        
        ChatManager.shared.addMessageFrom(data.name, message: data.message, date: data.date)
        
        return AddMessageResponse(request: data, success: true)
    }
}
