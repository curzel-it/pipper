//
//  Bookmark.swift
//  Pipper
//
//  Created by Federico Curzel on 08/08/22.
//

import Foundation

struct Bookmark: Codable, Identifiable, Equatable {
    
    let id: String
    let title: String
    let url: String
    let icon: String
}

extension URL {
    
    func asBookmark(title: String) -> Bookmark {
        Bookmark(
            id: UUID().uuidString,
            title: title,
            url: absoluteString,
            icon: favicon?.absoluteString ?? absoluteString
        )
    }
}
