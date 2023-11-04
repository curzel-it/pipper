import Combine
import SwiftUI

class AppState: ObservableObject {
    @Published private(set) var bookmarks: [Bookmark] = []
    @Published var history: [URL] = []
    @Published var accessoryMode: Bool = false {
        didSet {
            storedAccessoryMode = accessoryMode
            @Inject var windowManager: WindowManager
            windowManager.resetAccessoryMode(enabled: accessoryMode)
        }
    }
    @Published var isHovering: Bool = true {
        didSet {
            storedIsHovering = isHovering
        }
    }
    @Published var isLoading = false
    @Published private(set) var navigationRequest: NavigationRequest = .reload
    @Published var showHome: Bool = true
    @Published var showToolbar: Bool = true
    @Published var showSearch = false
    @Published var showSettings = false
    @Published var userAgent: String = "" {
        didSet {
            storedUserAgent = userAgent
        }
    }
    @Published var userMessage: UserMessage?
    @Published var vistedUrlsStack: [URL] = []
    @Published var windowOpacity: CGFloat = 1 {
        didSet {
            storedWindowOpacity = windowOpacity
        }
    }
    
    @AppStorage("homepageUrl") var homepageUrl: String = ""
    @AppStorage("accessoryMode") private var storedAccessoryMode = false
    @AppStorage("isHovering") private var storedIsHovering = true
    @AppStorage("searchEngineBaseUrl") var searchEngineBaseUrl: String = ""
    @AppStorage("bookmarks") private var storedBookmarks: Data?
    @AppStorage("userAgent") private var storedUserAgent: String = ""
    @AppStorage("windowWidth") private var windowWidth: Double = 600
    @AppStorage("windowHeight") private var windowHeight: Double = 600
    @AppStorage("windowOpacity") private var storedWindowOpacity: Double = 1
    
    lazy var webViewDelegate: WebViewDelegate = {
        WebViewDelegate(appState: self)
    }()
    
    init() {
        isHovering = self.storedIsHovering
        accessoryMode = self.storedAccessoryMode
        userAgent = self.storedUserAgent
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
