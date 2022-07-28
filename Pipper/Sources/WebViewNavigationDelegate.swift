//
//  WebViewNavigationDelegate.swift
//  Pipper
//
//  Created by Federico Curzel on 27/07/22.
//

import Foundation
import WebKit

class NavigationDelegate: NSObject, WKNavigationDelegate {
            
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
