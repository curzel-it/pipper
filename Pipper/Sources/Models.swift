//
//  Models.swift
//  Pipper
//
//  Created by Federico Curzel on 28/07/22.
//

import Foundation

// MARK: - Navigation

enum NavigationRequest {
    case reload
    case html(text: String, baseURL: URL?)
    case urlString(urlString: String)
    case url(url: URL)
    case search(input: String)
}

// MARK: - User Agents

class UserAgent {
    
    // swiftlint:disable line_length
    
    static let iPhone = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148"
    
    static let iPad = "Mozilla/5.0 (iPad; CPU OS 15_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/103.0.5060.63 Mobile/15E148 Safari/604.1"
    
    static let macBook = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1.2 Safari/605.1.15"
}

// MARK: - Search Engines

class SearchEngine {
    
    static let google = "https://google.com/search?q="
    static let duckDuckGo = "https://duckduckgo.com?q="
}

// MARK: - Sizes

class Size {
    
    static let i9b16w320 = CGSize(width: 320, height: 569)
    static let i9b16w370 = CGSize(width: 370, height: 658)
    static let i9b16w420 = CGSize(width: 420, height: 746)
    
    static let i9b24w320 = CGSize(width: 320, height: 853)
    static let i9b24w370 = CGSize(width: 370, height: 987)
    static let i9b24w420 = CGSize(width: 420, height: 1120)
    
    static let i16b11w430 = CGSize(width: 430, height: 296)
    static let i16b11w490 = CGSize(width: 490, height: 337)
    static let i16b11w550 = CGSize(width: 550, height: 378)
    
    static let i1b1w240 = CGSize(width: 240, height: 240)
    static let i1b1w360 = CGSize(width: 360, height: 360)
    static let i1b1w440 = CGSize(width: 440, height: 440)
    static let i1b1w520 = CGSize(width: 520, height: 520)
}

extension CGSize: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}

// MARK: - Bookmarks

struct Bookmark: Codable, Identifiable, Equatable {
    
    let id: String
    let title: String
    let url: String
    let icon: String
}
