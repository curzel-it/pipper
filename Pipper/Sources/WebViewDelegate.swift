//
//  WebViewDelegate.swift
//  Pipper
//
//  Created by Federico Curzel on 27/07/22.
//

import Combine
import Foundation
import WebKit

class WebViewDelegate: NSObject, WKNavigationDelegate {
        
    private var eventsSink: AnyCancellable!
    
    private var appState: AppState
    
    weak var webView: WKWebView?
    
    init(appState: AppState) {
        self.appState = appState
        super.init()
        
        eventsSink = appState.runtimeEvents.sink { [weak self] event in
            guard case .closing = event else { return }
            guard let webView = self?.webView else { return }
            webView.stopLoading()
            webView.loadHTMLString("", baseURL: nil)
            self?.webView = nil
        }
    }
    
    func setup(webView: WKWebView) {
        self.webView = webView
        webView.customUserAgent = appState.userAgent
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsMagnification = true
        webView.allowsLinkPreview = false
        webView.navigationDelegate = self
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction
    ) async -> WKNavigationActionPolicy {
        let navigationUrl = navigationAction.request.url?.absoluteString.lowercased()
        
        switch navigationUrl {
        case "project_github":
            let url = URL(string: "https://github.com/curzel-it/pipper")!
            NSWorkspace.shared.open(url)
            return .cancel
            
        case "author":
            let url = URL(string: "https://github.com/curzel-it")!
            NSWorkspace.shared.open(url)
            return .cancel
                        
        default: return .allow
        }
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse
    ) async -> WKNavigationResponsePolicy {
        .allow
    }
}

extension NSWorkspace {
    
    func open(_ urlString: String) {
        if let url = URL(string: urlString) {
            open(url)
        }
    }
}
