//
//  AppState.swift
//  Pipper
//
//  Created by Federico Curzel on 28/07/22.
//

import Combine
import SwiftUI

class AppState: ObservableObject {
    
    static let global = AppState()
        
    let runtimeEvents = CurrentValueSubject<RuntimeEvent, Never>(.loading)
    
    lazy var webViewDelegate: WebViewDelegate = WebViewDelegate()
    lazy var windowManager: WindowManager = WindowManager()
    
    @Published var userMessage: UserMessage?
    @Published var isHovering = true
    @Published var showHome = true
    @Published var showSearch = false
    @Published var navigationRequest: NavigationRequest = .urlString(urlString: SearchEngine.duckDuckGo)
    
    @Published var bookmarks: [Bookmark] = [] {
        didSet {
            saveBookmarks()
        }
    }
    
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
        
    @AppStorage("bookmarks") private var storedBookmarks: Data?
    @AppStorage("searchEngineBaseUrl") private var storedSearchEngineBaseUrl: String = SearchEngine.duckDuckGo
    @AppStorage("width") private var storedWidth: Double = Size.i9b24w320.width
    @AppStorage("height") private var storedHeight: Double = Size.i9b24w320.height
    @AppStorage("userAgent") private var storedUserAgent: String = UserAgent.iPad
    
    private init() {
        userAgent = storedUserAgent
        searchEngineBaseUrl = storedSearchEngineBaseUrl
        size = CGSize(width: storedWidth, height: storedHeight)
        loadBookmarks()
    }
    
    func loadBookmarks() {
        if let data = storedBookmarks,
            let value = try? JSONDecoder().decode([Bookmark].self, from: data) {
            self.bookmarks = value
        }
    }
    
    func saveBookmarks() {
        if let data = try? JSONEncoder().encode(bookmarks) {
            self.storedBookmarks = data
        }
    }
}

enum RuntimeEvent {
    case loading
    case launching
    case closing
}
