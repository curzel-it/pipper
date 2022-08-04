//
//  StorageService.swift
//  Pipper
//
//  Created by Federico Curzel on 28/07/22.
//

import Combine
import SwiftUI

class StorageService: ObservableObject {
    
    static let shared = StorageService()
    
    @Published private(set) var bookmarks: [Bookmark] = []
    
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
}

extension StorageService {
    
    func add(bookmark: Bookmark) {
        bookmarks = bookmarks.filter { $0.id != bookmark.id } + [bookmark]
        saveBookmarks()
    }
    
    func remove(bookmark: Bookmark) {
        bookmarks = bookmarks.filter { $0.id != bookmark.id }
        saveBookmarks()
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
