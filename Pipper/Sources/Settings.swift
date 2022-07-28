//
//  Settings.swift
//  Pipper
//
//  Created by Federico Curzel on 28/07/22.
//

import Schwifty
import SwiftUI

struct Settings: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .font(.title3)
                .positioned(.leading)
            
            VStack(spacing: 12) {
                Contents()
            }
            
            Button("Close", action: close)
                .positioned(.trailing)
        }
        .padding()
    }
    
    func close() {
        withAnimation {
            appState.showSettings = false
        }
    }
}

private struct Contents: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack {
            Text("Search Engine")
            TextField("https://...?q=", text: $appState.searchEngineBaseUrl)
        }
        Picker("User Agent", selection: $appState.userAgent) {
            Text("iPhone / Safari").tag(UserAgent.iPhone)
            Text("iPad / Safari").tag(UserAgent.iPad)
            Text("Desktop / Safari").tag(UserAgent.macBook)
        }
        Picker("Set Size", selection: $appState.size) {
            Text("9:16 | 320 x 569").tag(Size.i9b16w320)
            Text("9:16 | 370 x 658").tag(Size.i9b16w370)
            Text("9:16 | 420 x 746").tag(Size.i9b16w420)
            Text("9:24 | 320 x 853").tag(Size.i9b24w320)
            Text("9:24 | 370 x 987").tag(Size.i9b24w370)
            Text("9:24 | 420 x 1120").tag(Size.i9b24w420)
            Text("16:9 | 430 x 242").tag(Size.i16b9w430)
            Text("16:9 | 490 x 275").tag(Size.i16b9w490)
            Text("16:9 | 550 x 309").tag(Size.i16b9w550)
        }
    }
}
