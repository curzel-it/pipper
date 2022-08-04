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
        modifier(HintOnHover(text: hint))
    }
}

private struct HintOnHover: ViewModifier {
    
    @EnvironmentObject var appState: AppState
    
    let text: String
    
    func body(content: Content) -> some View {
        content.onHover { isHover in
            if isHover {
                withAnimation {
                    appState.userMessage = UserMessage(
                        text: text,
                        duracy: .long,
                        severity: .info
                    )
                }
            } else {
                guard let currentMesage = appState.userMessage else { return }
                if currentMesage.text == text {
                    withAnimation {
                        appState.userMessage = nil
                    }
                }
            }
        }
    }
}
