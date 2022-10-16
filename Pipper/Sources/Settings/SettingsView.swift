//
//  Settings.swift
//  Pipper
//
//  Created by Federico Curzel on 28/07/22.
//

import LaunchAtLogin
import Schwifty
import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        VStack(spacing: 20) {
            HomepageSelection()
            SearchEngineSection()
            UserAgentSection()
            SizeSection()
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
    @EnvironmentObject var storage: StorageService
    
    var body: some View {
        VStack {
            FormField(title: "Homepage Url") {
                TextField("", text: $storage.homepageUrl)
            }
            Text("(Leave blank to start on bookmarks page.)").textAlign(.trailing)
        }
    }
}

private struct SearchEngineSection: View {
    @EnvironmentObject var storage: StorageService
    
    var body: some View {
        VStack {
            FormField(title: "Search Engine") {
                Picker(selection: $storage.searchEngineBaseUrl) {
                    Text("DuckDuckGo").tag(SearchEngine.duckDuckGo)
                    Text("Google").tag(SearchEngine.google)
                } label: { EmptyView() }
            }
            FormField(title: "Search Engine Base Url") {
                TextField("https://...?q=", text: $storage.searchEngineBaseUrl)
            }
        }
    }
}

private struct UserAgentSection: View {
    @EnvironmentObject var storage: StorageService
        
    var body: some View {
        VStack {
            FormField(title: "User Agent") {
                Picker(selection: $storage.userAgent) {
                    Text("iPhone / Safari").tag(UserAgent.iPhone)
                    Text("iPad / Safari").tag(UserAgent.iPad)
                    Text("Desktop / Safari").tag(UserAgent.macBook)
                } label: { EmptyView() }
            }
            FormField(title: "Custom User Agent") {
                TextField("", text: $storage.userAgent)
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

private struct SizeSection: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        FormField(title: "Window Size") {
            Picker(selection: $appState.size) {
                Text("9:16 | 320 x 569").tag(Size.i9b16w320)
                Text("9:16 | 370 x 658").tag(Size.i9b16w370)
                Text("9:16 | 420 x 746").tag(Size.i9b16w420)
                Text("9:24 | 320 x 853").tag(Size.i9b24w320)
                Text("9:24 | 420 x 1120").tag(Size.i9b24w420)
                Text("16:11 | 430 x 396").tag(Size.i16b11w430)
                Text("16:11 | 490 x 337").tag(Size.i16b11w490)
                Text("1:1 | 440 x 440").tag(Size.i1b1w440)
            } label: { EmptyView() }
        }
    }
}
