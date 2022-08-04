//
//  Settings.swift
//  Pipper
//
//  Created by Federico Curzel on 28/07/22.
//

import Schwifty
import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        VStack {
            SearchEngineSection()
            UserAgentSection()
            SizeSection()
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
        // .keyboardShortcut(.init(.))
    }
}

private struct SearchEngineSection: View {
    
    @EnvironmentObject var globalState: GlobalState
    
    var body: some View {
        FormField(title: "Search Engine") {
            Picker(selection: $globalState.searchEngineBaseUrl) {
                Text("DuckDuckGo").tag(SearchEngine.duckDuckGo)
                Text("Google").tag(SearchEngine.google)
            } label: { EmptyView() }
        }
        FormField(title: "Search Engine Base Url") {
            TextField("https://...?q=", text: $globalState.searchEngineBaseUrl)
        }
    }
}

private struct UserAgentSection: View {
    
    @EnvironmentObject var globalState: GlobalState
        
    var body: some View {
        FormField(title: "User Agent") {
            Picker(selection: $globalState.userAgent) {
                Text("iPhone / Safari").tag(UserAgent.iPhone)
                Text("iPad / Safari").tag(UserAgent.iPad)
                Text("Desktop / Safari").tag(UserAgent.macBook)
            } label: { EmptyView() }
        }
        FormField(title: "Custom User Agent") {
            TextField("", text: $globalState.userAgent)
        }
    }
}

private struct SizeSection: View {
    
    @EnvironmentObject var globalState: GlobalState
    
    var body: some View {
        FormField(title: "Window Size") {
            Picker(selection: $globalState.size) {
                Text("9:16 | 320 x 569").tag(Size.i9b16w320)
                Text("9:16 | 370 x 658").tag(Size.i9b16w370)
                Text("9:16 | 420 x 746").tag(Size.i9b16w420)
                Text("9:24 | 320 x 853").tag(Size.i9b24w320)
                // Text("9:24 | 370 x 987").tag(Size.i9b24w370)
                Text("9:24 | 420 x 1120").tag(Size.i9b24w420)
                Text("16:11 | 430 x 396").tag(Size.i16b11w430)
                Text("16:11 | 490 x 337").tag(Size.i16b11w490)
                // Text("16:11 | 550 x 378").tag(Size.i16b11w550)
                // Text("1:1 | 360 x 360").tag(Size.i1b1w360)
                Text("1:1 | 440 x 440").tag(Size.i1b1w440)
                // Text("1:1 | 520 x 520").tag(Size.i1b1w520)
            } label: { EmptyView() }
        }
    }
}
/*
extension SettingsView {
    
    static func showWindow() {
        let view = NSHostingView(
            rootView: SettingsView()
                .environmentObject(AppState.global)
        )
        let window = NSWindow(
            contentRect: CGRect(x: 0, y: 0, width: 600, height: 400),
            styleMask: [.closable, .titled, .resizable],
            backing: .buffered,
            defer: true
        )
        window.title = "Pipper Settings"
        window.contentView?.addSubview(view)
        view.constrainToFillParent()
        window.show()
    }
}
*/
