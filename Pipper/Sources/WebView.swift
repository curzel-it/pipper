//
//  WebView.swift
//  Pipper
//
//  Created by Federico Curzel on 27/07/22.
//

import Combine
import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    
    @EnvironmentObject var appState: AppState
        
    func makeNSView(context: Context) -> some NSView {
        return MyWebView()
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        // ...
    }
}

private class MyWebView: WKWebView {
    
    let appState = AppState.global
    
    private var userAgentSink: AnyCancellable!
    private var requestsSink: AnyCancellable!
    
    init() {
        super.init(frame: .zero, configuration: WKWebViewConfiguration())
        appState.webViewDelegate.setup(webView: self)
        loadUserAgent()
        loadRequests()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadUserAgent() {
        userAgentSink = appState.$userAgent.sink { userAgent in
            self.customUserAgent = userAgent
            self.reload()
        }
    }
    
    private func loadRequests() {
        requestsSink = appState.$navigationRequest.sink { request in
            self.load(request)
        }
    }
    
    func load(_ request: NavigationRequest) {
        switch request {
            
        case .reload: reload()
            
        case .html(let text, let url):
            loadHTMLString(text, baseURL: url)
            
        case .url(let url):
            load(URLRequest(url: url))
            
        case .urlString(let urlString):
            if let url = URL(string: urlString) {
                load(.url(url: url))
            }
        }
    }
}
