import SwiftUI

struct UserMessage {
    let text: String
    let duracy: Duracy
    let severity: Severity
    
    enum Duracy: TimeInterval {
        case short = 2
        case long = 5
    }
    
    enum Severity {
        case error
        case warning
        case info
        case success
    }
}

extension UserMessage: Equatable {
    static func == (lhs: UserMessage, rhs: UserMessage) -> Bool {
        lhs.text == rhs.text && lhs.severity == rhs.severity
    }
}
