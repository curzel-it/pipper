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
                WebBackTool()
                HomeTool()
                WebTool()
                SearchTool()
                SearchFromClipboardTool()
                CopyUrlTool()
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

private struct WebBackTool: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        if !appState.showHome, appState.vistedUrlsStack.count >= 2 {
            Tool(icon: "arrow.left") {
                _ = appState.vistedUrlsStack.popLast()
                guard let next = appState.vistedUrlsStack.popLast() else { return }
                appState.load(.url(url: next))
            }
            .onHover(hint: "Goes back to latest visited url")
        }
    }
}

private struct CopyUrlTool: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        if !appState.showHome {
            Tool(icon: "square.and.arrow.up") {
                guard let url = appState.vistedUrlsStack.last else { return }
                let data = url.absoluteString.data(using: .utf8)
                NSPasteboard.general.setData(data, forType: .string)
                appState.userMessage = .init(text: "Copied!", duracy: .short, severity: .info)
            }
            .onHover(hint: "Copy the current URL to clipboard")
        }
    }
}

private struct HoverTool: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Spacer()
        Toggle(isOn: $appState.isHovering, label: { EmptyView() })
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
            appState.load(.search(input: terms))
        }
        .keyboardShortcut(.init("V"), modifiers: [.command, .shift])
        .onHover(hint: "Cmd + Shift + V\nSearch text from clipboard")
    }
}

private struct ReloadTool: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        if !appState.showHome {
            Tool(icon: "arrow.counterclockwise") {
                appState.load(.reload)
            }
            .keyboardShortcut(.init("R"), modifiers: [.command])
            .onHover(hint: "Cmd + R\nReload the page")
        }
    }
}

private struct SettingsTool: View {
    
    @EnvironmentObject var appState: AppState
        
    var body: some View {
        if appState.showHome {
            Tool(icon: "gearshape") {
                appState.showSettings = true
            }
            .onHover(hint: "Open settings window")
        }
    }
}
