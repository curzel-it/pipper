//
//  Tools.swift
//  Pipper
//
//  Created by Federico Curzel on 28/07/22.
//

import SwiftUI

struct Toolbar: View {
            
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack {
            HomeTool()
            SearchTool()
            SearchFromClipboardTool()
            ReloadTool()
            SettingsTool()
            Spacer()
        }
        .padding(8)
    }
}

private struct Tool: View {
    
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Spacer()
        Button(action: action, label: { Image(systemName: icon) })
    }
}

// MARK: - Default Tools

private struct HomeTool: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Tool(icon: "house") {
            appState.navigationRequest = .mainBundleHtmlFile(name: "homepage")
        }
    }
}

private struct SearchTool: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Tool(icon: "magnifyingglass") {
            withAnimation {
                appState.showSearch = true
            }
        }
    }
}

private struct SearchFromClipboardTool: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Tool(icon: "doc.on.clipboard") {
            let vm = SearchViewModel()
            vm.text = NSPasteboard.general.string(forType: .string) ?? ""
            vm.searchOrVisit()
        }
        .keyboardShortcut(.init("V"), modifiers: [.command, .shift])
    }
}

private struct ReloadTool: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Tool(icon: "arrow.counterclockwise") {
            appState.navigationRequest = .reload
        }
    }
}

private struct SettingsTool: View {
    
    @EnvironmentObject var appState: AppState
    
    var iconName: String {
        appState.showSettings ? "gearshape.fill" : "gearshape"
    }
    
    var body: some View {
        Tool(icon: iconName) {
            withAnimation {
                appState.showSettings = !appState.showSettings
            }
        }
    }
}
