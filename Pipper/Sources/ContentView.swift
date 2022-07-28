//
//  ContentView.swift
//  Pipper
//
//  Created by Federico Curzel on 28/07/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            WebView()
            Rectangle().fill(Color.tertiaryLabel, style: .init()).frame(height: 1)
            Toolbar()
            if appState.showSettings {
                Settings()
            }
            if appState.showSearch {
                Search()
            }
        }
        .onWindow {
            appState.windowManager.setup(window: $0)
        }
    }
}
