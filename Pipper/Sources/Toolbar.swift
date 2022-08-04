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
        VStack(spacing: 0) {
            Rectangle().fill(Color.tertiaryLabel, style: .init()).frame(height: 1)
            HStack {
                HomeTool()
                WebTool()
                BookmarkTool()
                SearchTool()
                SearchFromClipboardTool()
                ReloadTool()
                SettingsTool()
                HoverTool()
            }
            .padding(8)
        }
    }
}

private struct Tool: View {
    
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Spacer()
        Button {
            withAnimation {
                action()
            }
        } label: {
            Image(systemName: icon)
        }
    }
}

// MARK: - Default Tools

private struct HoverTool: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Spacer()
        Toggle("Hover", isOn: $appState.isHovering)
            .lineLimit(1)
            .toggleStyle(.switch)
            .onHover(hint: "If on the window will stay above all other windows.")
    }
}

private struct HomeTool: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        if !appState.showHome {
            Tool(icon: "house") { appState.showHome = true }
                .onHover(hint: "Shows your bookmarks")
        }
    }
}

private struct BookmarkTool: View {
    
    @EnvironmentObject var appState: AppState
    
    var isBookmarked = false
    
    var icon: String {
        isBookmarked ? "bookmark.slash" : "bookmark"
    }
    
    var body: some View {
        if !appState.showHome {
            Tool(icon: icon) {
                if isBookmarked {
                    // appState.bookmarks.remove { ... }
                } else {
                    // appState.bookmarks.append(..
                }
            }
            .onHover(hint: "Adds this page to your bookmarks")
        }
    }
}

private struct WebTool: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        if appState.showHome {
            Tool(icon: "globe") { appState.showHome = false }
                .onHover(hint: "Go back to the webview")
        }
    }
}

private struct SearchTool: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Tool(icon: "magnifyingglass") { appState.showSearch = true }
            .keyboardShortcut(.init("F"), modifiers: [.command, .shift])
            .onHover(hint: "Cmd + Shift + F\nOpen up the search bar")
    }
}

private struct SearchFromClipboardTool: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Tool(icon: "doc.on.clipboard") {
            let terms = NSPasteboard.general.string(forType: .string) ?? ""
            appState.navigationRequest = .search(input: terms)
        }
        .keyboardShortcut(.init("V"), modifiers: [.command, .shift])
        .onHover(hint: "Cmd + Shift + V\nSearch text from clipboard")
    }
}

private struct ReloadTool: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Tool(icon: "arrow.counterclockwise") {
            appState.navigationRequest = .reload
        }
        .keyboardShortcut(.init("R"), modifiers: [.command])
        .onHover(hint: "Cmd + R\nReload the page")
    }
}

private struct SettingsTool: View {
    
    @EnvironmentObject var appState: AppState
        
    var body: some View {
        Tool(icon: "gearshape") {
            appState.showSettings = true
        }
        .onHover(hint: "Open settings window")
    }
}
