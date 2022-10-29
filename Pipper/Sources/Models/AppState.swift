import Combine
import SwiftUI

class AppState: ObservableObject {
    @Published private(set) var bookmarks: [Bookmark] = []
    @Published var history: [URL] = []
    @Published var isHovering: Bool = true {
        didSet {
            self.storedIsHovering = isHovering
        }
    }
    @Published var isLoading = false
    @Published private(set) var navigationRequest: NavigationRequest = .reload
    @Published var showAdditionalInfo = true
    @Published var showHome: Bool = true
    @Published var showSearch = false
    @Published var showSettings = false
    @Published var userAgent: String = "" {
       didSet {
           self.storedUserAgent = userAgent
       }
   }
    @Published var userMessage: UserMessage?
    @Published var vistedUrlsStack: [URL] = []
            
    @AppStorage("homepageUrl") var homepageUrl: String = ""
    @AppStorage("isHovering") private var storedIsHovering = true
    @AppStorage("searchEngineBaseUrl") var searchEngineBaseUrl: String = ""
    @AppStorage("bookmarks") private var storedBookmarks: Data?
    @AppStorage("userAgent") private var storedUserAgent: String = ""
    @AppStorage("windowWidth") private var windowWidth: Double = 600
    @AppStorage("windowHeight") private var windowHeight: Double = 600
        
    let runtimeEvents = CurrentValueSubject<RuntimeEvent, Never>(.loading)
    
    lazy var webViewDelegate: WebViewDelegate = {
        WebViewDelegate(appState: self)
    }()
    
    lazy var windowManager: WindowManager = {
        WindowManager(appState: self)
    }()
    
    init() {
        self.isHovering = self.storedIsHovering
        self.userAgent = self.storedUserAgent
        loadBookmarks()
        loadInitialContent()
    }
    
    private func loadInitialContent() {
        if let homeUrl = URL(string: homepageUrl) {
            navigationRequest = .url(url: homeUrl)
            showHome = false
        } else {
            navigationRequest = .urlString(urlString: "about:blank")
            showHome = true
        }
    }
    
    func load(_ request: NavigationRequest) {
        self.showHome = false
        self.showSettings = false
        self.showSearch = false
        self.navigationRequest = request
    }
}

enum RuntimeEvent {
    case loading
    case launching
    case closing
}

extension AppState {
    func add(bookmark: Bookmark) {
        bookmarks = bookmarks.filter { $0.id != bookmark.id } + [bookmark]
        saveBookmarks()
    }
    
    func remove(bookmark: Bookmark) {
        bookmarks = bookmarks.filter { $0.id != bookmark.id }
        saveBookmarks()
    }
    
    func remove(bookmark: URL) {
        bookmarks = bookmarks.filter { $0.url != bookmark.absoluteString }
        saveBookmarks()
    }
    
    func isBookmarked(_ url: URL) -> Bool {
        bookmarks.contains { $0.url == url.absoluteString }
    }
    
    fileprivate func loadBookmarks() {
        if let data = storedBookmarks,
            let value = try? JSONDecoder().decode([Bookmark].self, from: data) {
            self.bookmarks = value
        }
    }
    
    fileprivate func saveBookmarks() {
        if let data = try? JSONEncoder().encode(bookmarks) {
            self.storedBookmarks = data
        }
    }
}

extension AppState {
    var windowSize: CGSize {
        get {
            CGSize(
                width: CGFloat(windowWidth),
                height: CGFloat(windowHeight)
            )
        }
        set {
            self.windowWidth = newValue.width
            self.windowHeight = newValue.height
        }
    }
}
