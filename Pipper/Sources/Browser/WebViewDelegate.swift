import Combine
import Foundation
import WebKit

class WebViewDelegate: NSObject, WKNavigationDelegate {
    private var eventsSink: AnyCancellable!
    private let appState: AppState
    weak var webView: WKWebView?
    
    init(appState: AppState) {
        self.appState = appState
        super.init()
        setKillWebViewWhenWindowCloses()
    }
    
    private func setKillWebViewWhenWindowCloses() {
        // Video playing in the WKWebView continue to play after the window
        // gets closed, this does the trick.
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
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        appState.isLoading = false
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction
    ) async -> WKNavigationActionPolicy {
        guard let navigationUrl = navigationAction.request.url else { return .allow }
        let urlString = navigationUrl.absoluteString.lowercased()
        
        switch urlString {
        case "project_github":
            let url = URL(string: "https://github.com/curzel-it/pipper")!
            NSWorkspace.shared.open(url)
            return .cancel
            
        case "author":
            let url = URL(string: "https://github.com/curzel-it")!
            NSWorkspace.shared.open(url)
            return .cancel
            
        default:
            trackPageLoad(url: navigationUrl)
            return .allow
        }
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse
    ) async -> WKNavigationResponsePolicy {
        .allow
    }
    
    private func trackPageLoad(url: URL) {
        guard url.absoluteString != "about:blank" else { return }
        Task { @MainActor in
            appState.vistedUrlsStack.append(url)
            appState.isLoading = true
        }
    }
}

extension NSWorkspace {
    func open(_ urlString: String) {
        if let url = URL(string: urlString) {
            open(url)
        }
    }
}
