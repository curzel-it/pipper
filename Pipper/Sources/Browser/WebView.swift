import Combine
import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    @EnvironmentObject var appState: AppState
    
    func makeNSView(context: Context) -> some NSView {
        return MyWebView(appState: appState)
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        // ...
    }
}

private class MyWebView: WKWebView {
    let appState: AppState
    
    private var userAgentSink: AnyCancellable!
    private var requestsSink: AnyCancellable!
    
    init(appState: AppState) {
        self.appState = appState
        super.init(frame: .zero, configuration: WKWebViewConfiguration())
        appState.webViewDelegate.setup(webView: self)
        bindUserAgent()
        bindNavigationRequests()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func validateProposedFirstResponder(_ responder: NSResponder, for event: NSEvent?) -> Bool {
        true
    }
    
    private func bindUserAgent() {
        userAgentSink = appState.$userAgent.sink { userAgent in
            self.customUserAgent = userAgent
            self.reload()
        }
    }
    
    private func bindNavigationRequests() {
        requestsSink = appState.$navigationRequest.sink { request in
            Task { @MainActor in
                self.load(request)
            }
        }
    }
    
    func load(_ request: NavigationRequest) {
        switch request {
        case .reload: reload()
        case .html(let text, let url): loadHTMLString(text, baseURL: url)
        case .url(let url): load(URLRequest(url: url))
        case .urlString(let urlString): load(urlString)
        case .search(let userInput): search(userInput)
        }
    }
    
    private func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            load(.url(url: url))
        }
    }
    
    private func search(_ userInput: String) {
        let url: URL?
        let text = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let inputUrl = URL(string: text), inputUrl.scheme != nil {
            url = inputUrl
        } else {
            let param = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let urlString = "\(appState.searchEngineBaseUrl)\(param ?? "")"
            url = URL(string: urlString)
        }
        if let url = url {
            load(URLRequest(url: url))
        }
    }
}
