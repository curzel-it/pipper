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

struct UserMessages: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        if let message = appState.userMessage {
            Text(message.text)
                .multilineTextAlignment(.center)
                .foregroundColor(message.severity.color)
                .padding()
                .background(Color.secondaryBackground)
                .cornerRadius(8)
                .shadow(radius: 16)
                .positioned(.bottom)
                .padding(.bottom, 50)
                .onReceive(appState.$userMessage) { message in
                    if let message = message {
                        DispatchQueue.main.asyncAfter(deadline: .now() + message.duracy.rawValue) {
                            if appState.userMessage == message {
                                withAnimation {
                                    appState.userMessage = nil
                                }
                            }
                        }
                    }
                }
        }
    }
}

extension UserMessage.Severity {
    
    var color: Color {
        switch self {
        case .error: return .error
        case .warning: return .warning
        case .info: return .label
        case .success: return .success
        }
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
