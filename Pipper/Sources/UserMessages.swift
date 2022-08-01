//
//  UserMessages.swift
//  Pipper
//
//  Created by Federico Curzel on 30/07/22.
//

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

extension View {
    
    func onHover(hint: String) -> some View {
        self.onHover { isHover in
            if isHover {
                withAnimation {
                    AppState.global.userMessage = UserMessage(
                        text: hint,
                        duracy: .long,
                        severity: .info
                    )
                }
            } else {
                guard let currentMesage = AppState.global.userMessage else { return }
                if currentMesage.text == hint {
                    withAnimation {
                        AppState.global.userMessage = nil
                    }
                }
            }
        }
    }
}

