//
//  AppState.swift
//  Pipper
//
//  Created by Federico Curzel on 28/07/22.
//

import SwiftUI

class AppState: ObservableObject {
    
    static let global = AppState()
    
    let webViewNavigationDelegate = NavigationDelegate()
    var windowManager: WindowManager!
    
    @Published var showSettings = false
    @Published var showSearch = false
    @Published var navigationRequest: NavigationRequest = .urlString(urlString: "https://news.ycombinator.com/")  // .mainBundleHtmlFile(name: "homepage")
    
    @Published var searchEngineBaseUrl: String = "" {
        didSet {
            storedSearchEngineBaseUrl = searchEngineBaseUrl
        }
    }
    
    @Published var userAgent: String = "" {
        didSet {
            storedUserAgent = userAgent
        }
    }
    
    @Published var size: CGSize = .zero {
        didSet {
            storedWidth = size.width
            storedHeight = size.height
        }
    }
    
    @AppStorage("searchEngineBaseUrl") private var storedSearchEngineBaseUrl: String = "https://duckduckgo.com/?q="
    @AppStorage("width") private var storedWidth: Double = Size.i9b24w320.width
    @AppStorage("height") private var storedHeight: Double = Size.i9b24w320.height
    @AppStorage("userAgent") private var storedUserAgent: String = UserAgent.iPad
    
    init() {
        userAgent = storedUserAgent
        searchEngineBaseUrl = storedSearchEngineBaseUrl
        size = CGSize(width: storedWidth, height: storedHeight)
        windowManager = WindowManager(appState: self)
    }
}
