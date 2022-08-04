//
//  ContentView.swift
//  Pipper
//
//  Created by Federico Curzel on 28/07/22.
//

import Schwifty
import SwiftUI

struct ContentView: View {
        
    @StateObject var appState = AppState()
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Homepage()
                    .opacity(appState.showHome ? 1 : 0)
                WebView()
                    .opacity(appState.showHome ? 0 : 1)
                
                if appState.showSearch { Search() }
                UserMessages()
            }
            Toolbar()
        }
        .sheet(isPresented: $appState.showSettings) {
            SettingsView()
        }
        .onWindow {
            appState.windowManager.setup(window: $0)
        }
        .environmentObject(appState)
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
                .padding(.bottom, 100)
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
