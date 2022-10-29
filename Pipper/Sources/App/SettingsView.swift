import LaunchAtLogin
import Schwifty
import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings").font(.title.bold()).positioned(.leading)
            HomepageSelection()
            SearchEngineSection()
            UserAgentSection()
            // SizeSection()
            WindowSection()
            LaunchAtLoginSection()
            Footer().padding(.top)
        }
        .padding()
    }
}

private struct Footer: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Button("Done") {
            withAnimation {
                appState.showSettings = false
            }
        }
        .positioned(.trailing)
        .keyboardShortcut(.cancelAction)
    }
}

private struct HomepageSelection: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            FormField(title: "Homepage Url") {
                TextField("", text: $appState.homepageUrl)
            }
            Text("Leave blank to start on bookmarks page.")
                .font(.caption)
                .positioned(.trailing)
        }
    }
}

private struct SearchEngineSection: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            FormField(title: "Search Engine") {
                Picker(selection: $appState.searchEngineBaseUrl) {
                    Text("DuckDuckGo").tag(SearchEngine.duckDuckGo)
                    Text("Google").tag(SearchEngine.google)
                } label: { EmptyView() }
            }
            FormField(title: "Search Engine Base Url") {
                TextField("https://...?q=", text: $appState.searchEngineBaseUrl)
            }
        }
    }
}

private struct UserAgentSection: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            FormField(title: "User Agent") {
                Picker(selection: $appState.userAgent) {
                    Text("iPhone / Safari").tag(UserAgent.iPhone)
                    Text("iPad / Safari").tag(UserAgent.iPad)
                    Text("Desktop / Safari").tag(UserAgent.macBook)
                } label: { EmptyView() }
            }
            FormField(title: "Custom User Agent") {
                TextField("", text: $appState.userAgent)
            }
        }
    }
}

private struct LaunchAtLoginSection: View {
    @EnvironmentObject var appState: AppState
    
    var launchAtLogin: Binding<Bool> = Binding {
        LaunchAtLogin.isEnabled
    } set: { newValue in
        LaunchAtLogin.isEnabled = newValue
    }
    
    var body: some View {
        FormField(title: "Launch at login") {
            HStack {
                Toggle(isOn: launchAtLogin, label: { EmptyView() })
                    .toggleStyle(.switch)
                Spacer()
            }
        }
    }
}

private struct WindowSection: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        FormField(title: "Always on top") {
            VStack {
                Toggle(isOn: $appState.isHovering, label: { EmptyView() })
                    .toggleStyle(.switch)
                    .positioned(.leading)
                Text("Pipper will stay on top of other windows if enabled")
                    .font(.caption)
                    .positioned(.trailing)
            }
        }
    }
}
