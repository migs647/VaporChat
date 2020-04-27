import Vapor

/// A single entry of a Todo list.
struct Message: Content {
    var uuid = UUID().uuidString
    var name: String
    var message: String
    var date: Date
}

struct AddMessageResponse: Content {
    var request: Message
    var success: Bool
}

struct CheckMessagesSinceRequest: Content {
    var date: Date
}

struct CheckMessagesSinceResponse: Content {
    var date: Date
    var messages: [Message]
}
