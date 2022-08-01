//
//  Search.swift
//  Pipper
//
//  Created by Federico Curzel on 28/07/22.
//

import Foundation
import SwiftUI

struct Search: View {
    
    @EnvironmentObject var appState: AppState
    
    @StateObject var viewModel = SearchViewModel()
    
    @FocusState var focused: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            TextField("Search + Enter", text: $viewModel.text)
                .textFieldStyle(.plain)
                .padding()
                .onSubmit(viewModel.searchOrVisit)
                .focused($focused)
                .onAppear { focused = true }
            
            Button(action: viewModel.searchOrVisit) {
                Image(systemName: "magnifyingglass")
            }
            .keyboardShortcut(.return)
            .onHover(hint: "RETURN 􀅇\nSearches your input")
            
            Button(action: viewModel.close) {
                Image(systemName: "xmark")
            }
            .keyboardShortcut(.cancelAction)
            .onHover(hint: "ESC 􀆧\nCloses the search bar")
            
            Button(action: viewModel.visitSearchEngineHome) {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
            }
            .keyboardShortcut(.init("E"), modifiers: [.command, .shift])
            .onHover(hint: "CMD + Shift + E\nOpen Search Engine homepage")
        }
        .padding(.horizontal)
        .background(Color.secondaryBackground)
        .cornerRadius(8)
        .shadow(radius: 16)
        .padding(.horizontal, 40)
        .onSubmit(viewModel.searchOrVisit)
    }
}

class SearchViewModel: ObservableObject {
    
    @Published var text: String = ""
    
    var appState: AppState { AppState.global }
    
    func searchOrVisit() {
        if let url = URL(string: text), url.scheme != nil {
            appState.navigationRequest = .url(url: url)
            close()
            return
        }
        search()
        close()
    }
    
    func visitSearchEngineHome() {
        withAnimation {
            appState.showSearch = false
            appState.showHome = false
            appState.navigationRequest = .urlString(urlString: appState.searchEngineBaseUrl)
        }
    }
    
    private func search() {
        let keywords = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let urlString = "\(appState.searchEngineBaseUrl)\(keywords ?? "")"
        
        guard let url = URL(string: urlString) else { return }
        withAnimation {
            appState.showHome = false
            appState.navigationRequest = .url(url: url)
        }
    }
    
    func close() {
        withAnimation {
            AppState.global.showSearch = false
        }
    }
    
    func clear() {
        withAnimation {
            text = ""
        }
    }
}
