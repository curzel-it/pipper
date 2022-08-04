//
//  Search.swift
//  Pipper
//
//  Created by Federico Curzel on 28/07/22.
//

import Combine
import Foundation
import SwiftUI

struct Search: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var globalState: GlobalState
        
    @State var text: String = ""
    
    @FocusState var focused: Bool
    
    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .textFieldStyle(.plain)
                .padding()
                .onSubmit(searchOrVisit)
                .focused($focused)
                .onAppear { focused = true }
                .padding(.trailing)
                        
            SearchCurrentText(action: searchOrVisit)
            CloseSearchBar()
            VisitSearchEngineHome()
        }
        .padding(.trailing)
        .background(Color.secondaryBackground)
        .cornerRadius(8)
        .shadow(radius: 16)
        .padding(.horizontal, 40)
        .onSubmit(searchOrVisit)
    }
    
    private func searchOrVisit() {
        appState.showHome = false
        appState.navigationRequest = .search(input: text)
        close()
    }
    
    private func close() {
        withAnimation {
            appState.showSearch = false
        }
    }
}

private struct SearchCurrentText: View {
        
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var globalState: GlobalState
    
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "magnifyingglass")
        }
        .keyboardShortcut(.return)
        .onHover(hint: "RETURN 􀅇\nSearches your input")
    }
}

private struct CloseSearchBar: View {
        
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var globalState: GlobalState
    
    var body: some View {
        Button(action: close) {
            Image(systemName: "xmark")
        }
        .keyboardShortcut(.cancelAction)
        .onHover(hint: "ESC 􀆧\nCloses the search bar")
    }
    
    func close() {
        withAnimation {
            appState.showSearch = false
        }
    }
}

private struct VisitSearchEngineHome: View {
        
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var globalState: GlobalState
    
    var body: some View {
        Button(action: visitSearchEngineHome) {
            Image(systemName: "arrow.up.left.and.arrow.down.right")
        }
        .keyboardShortcut(.init("E"), modifiers: [.command, .shift])
        .onHover(hint: "CMD + Shift + E\nOpen Search Engine homepage")
    }
    
    func visitSearchEngineHome() {
        withAnimation {
            appState.showSearch = false
            appState.showHome = false
            appState.navigationRequest = .urlString(urlString: globalState.searchEngineBaseUrl)
        }
    }
}
