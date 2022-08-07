//
//  WebViewInsights.swift
//  Pipper
//
//  Created by Federico Curzel on 05/08/22.
//

import Combine
import SwiftUI

struct Browser: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            WebView()
            if appState.showAdditionalInfo {
                VStack(spacing: 0) {
                    Rectangle().fill(Color.tertiaryLabel, style: .init()).frame(height: 1)
                    UrlBar()
                }
            }
        }
    }
}

private struct UrlBar: View {
    
    @EnvironmentObject var appState: AppState
    
    var currentUrl: String {
        appState.vistedUrlsStack.last?.absoluteString ?? ""
    }
    
    var body: some View {
        HStack(spacing: 12) {
            if appState.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(0.6)
            }
            Text(currentUrl)
                .font(.caption)
                .lineLimit(2)
                .onTapGesture {
                    let data = currentUrl.data(using: .utf8)
                    NSPasteboard.general.setData(data, forType: .string)
                    appState.userMessage = .init(text: "Url Copied!", duracy: .short, severity: .info)
                }
        }
        .padding(8)
    }
}
