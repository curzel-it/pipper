//
//  PipperApp.swift
//  Pipper
//
//  Created by Federico Curzel on 27/07/22.
//

import OnWindow
import SwiftUI

@main
struct PipperApp: App {
    
    @StateObject var globalState = GlobalState.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(globalState)
        }
        .windowStyle(.hiddenTitleBar)
    }
}
