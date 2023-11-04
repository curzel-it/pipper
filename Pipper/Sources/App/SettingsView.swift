import Combine
import LaunchAtLogin
import Schwifty
import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(spacing: .md) {
            Text("Settings").font(.title.bold()).positioned(.leading)
            HomepageSelection()
            SearchEngineSection()
            UserAgentSection()
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
        FormField(
            title: "Homepage Url",
            hint: "Leave blank to start on bookmarks page."
        ) {
            TextField("", text: $appState.homepageUrl)
        }
    }
}

private struct SearchEngineSection: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
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

private struct UserAgentSection: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
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
        FormField(
            title: "Stay over other apps",
            hint: """
Pipper window will stay always on top of other windows.
Can be toggled on/off with `CMD + Shift + P`
"""
        ) {
            Toggle(isOn: $appState.isHovering, label: { EmptyView() })
                .toggleStyle(.switch)
                .positioned(.leading)
        }
        FormField(
            title: "Join fullscreen spaces",
            hint: """
Note: Close and Relaunch the app to apply!
By default Pipper window automatically joins any active space (even with this off).
With this option on it will also join spaces dedicated to fullscreen apps.
"""
        ) {
            Toggle(isOn: $appState.accessoryMode, label: { EmptyView() })
                .toggleStyle(.switch)
                .positioned(.leading)
        }
        FormField(title: "Window Opacity") {
            Slider(value: $appState.windowOpacity, in: (0.1...1))
        }
    }
}
