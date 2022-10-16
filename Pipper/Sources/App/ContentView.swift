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
                
                if appState.showSearch { SearchBar() }
                UserMessages()
            }
            if appState.showAdditionalInfo { Toolbar() }
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
