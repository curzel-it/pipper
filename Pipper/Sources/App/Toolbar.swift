import SwiftUI

extension View {
    func browsingToolbar() -> some View {
        self.toolbar {
            ToolbarItem { WebHomeToggle() }
            ToolbarItem { SettingsTool() }
            ToolbarItem { ReloadTool() }
            ToolbarItem { ShareTool() }
            ToolbarItem { SearchFromClipboardTool() }
            ToolbarItem { SearchTool() }
        }
    }
}

private struct Tool: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button {
            withAnimation { action() }
        } label: {
            Image(systemName: icon)
        }
    }
}

private struct WebHomeToggle: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Tool(icon: appState.showHome ? "network" : "house.fill") {
            appState.showHome = !appState.showHome
            appState.showSearch = false
            appState.showSettings = false
        }
        .keyboardShortcut(.init("B"), modifiers: [.command, .shift])
        .onHover(hint: "Cmd + Shift + B\nSwitch between home and web")
    }
}

private struct SearchTool: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Tool(icon: "magnifyingglass") {
            appState.showSearch = true
            appState.showSettings = false
        }
        .keyboardShortcut(.init("F"), modifiers: [.command, .shift])
        .onHover(hint: "Cmd + Shift + F\nOpen up the search bar")
    }
}

private struct SettingsTool: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Tool(icon: "gearshape") {
            appState.showSearch = false
            appState.showSettings = true
        }
        .onHover(hint: "Open up settings panel")
    }
}

private struct ReloadTool: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Tool(icon: "arrow.counterclockwise") {
            appState.load(.reload)
        }
        .keyboardShortcut(.init("R"), modifiers: [.command])
        .onHover(hint: "Cmd + R\nReload the page")
    }
}

private struct ShareTool: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Tool(icon: "square.and.arrow.up") {
            guard let url = appState.vistedUrlsStack.last?.absoluteString else { return }
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(url, forType: .string)
            appState.userMessage = .init(text: "Copied!", duracy: .short, severity: .info)
        }
        .keyboardShortcut(.init("C"), modifiers: [.command, .shift])
        .onHover(hint: "Copy the current URL to clipboard")
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

