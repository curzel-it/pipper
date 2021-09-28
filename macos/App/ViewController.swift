//
//  ViewController.swift
//  App
//
//  Created by Federico Curzel on 16/04/2020.
//  Copyright © 2020 Federico Curzel. All rights reserved.
//

import Cocoa
import WebKit
import RxSwift

class ViewController: NSViewController {
            
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppDelegate.navigationRequest.subscribe(onNext: { request in
            switch request {
            case .url(let url):
                self.webView.load(URLRequest(url: url))
            case .reload:
                self.webView.reload()
            case .homepage:
                self.loadHomepage()
            }
        }).disposed(by: self.disposeBag)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.setupWindow()
        self.setupWebView()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.positionWindow()
    }
    
    let disposeBag = DisposeBag()
}

// MARK: - Window

extension ViewController {
    
    func setupWindow() {
        guard let window = self.view.window else { return }
        window.title = "Pipper"
        window.minSize = CGSize(width: 100, height: 100)
        window.level = .mainMenu
        window.collectionBehavior = .canJoinAllSpaces
        // window.styleMask = .borderless
        // window.isMovableByWindowBackground = true
        // window.hasShadow = false
        // window.isOpaque = false
        // window.backgroundColor = .clear
    }
    
    func positionWindow() {
        DispatchQueue.main.async {
            guard let window = self.view.window else { return }
            window.setFrame(
                CGRect(origin: .zero, size: CGSize(width: 320, height: 480)),
                display: true
            )
        }
    }
}

// MARK: - WebView

extension ViewController: WKNavigationDelegate {
    
    func setupWebView() {
        self.webView.customUserAgent = kUserAgent
        self.webView.navigationDelegate = self
    }
    
    func loadHomepage() {
        guard let url = Bundle.main.url(forResource: "homepage", withExtension: "html") else { return }
        guard let html = try? String(contentsOf: url) else { return }
        self.webView.loadHTMLString(html, baseURL: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let s = webView.title { self.view.window?.title = s }
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        switch url.absoluteURL.lastPathComponent {
        case kProjectGitHub:
            let url = URL(string: kProjectGitHubURL)!
            NSWorkspace.shared.open(url)
            decisionHandler(.cancel)
            return
            
        default:
            decisionHandler(.allow)
        }
    }
}

let kProjectGitHub = "project_github"
let kProjectGitHubURL = "https://github.com/curzel-it/pipper"
let kUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko)"
