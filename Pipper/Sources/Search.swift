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
            TextField("Search...", text: $viewModel.text)
                .textFieldStyle(.plain)
                .padding()
                .onSubmit(viewModel.searchOrVisit)
                .focused($focused)
                .onAppear { focused = true }
            
            Button("Search", action: viewModel.searchOrVisit)
                .padding(.trailing)
        }
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
    
    private func search() {
        let keywords = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let urlString = "\(appState.searchEngineBaseUrl)\(keywords ?? "")"
        
        guard let url = URL(string: urlString) else { return }
        appState.navigationRequest = .url(url: url)
    }
    
    func close() {
        withAnimation {
            AppState.global.showSearch = false
        }
    }
    
    func clear() {
        text = ""
    }
}
