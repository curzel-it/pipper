//
//  NavigationRequest.swift
//  Pipper
//
//  Created by Federico Curzel on 08/08/22.
//

import Foundation

enum NavigationRequest {
    case reload
    case html(text: String, baseURL: URL?)
    case urlString(urlString: String)
    case url(url: URL)
    case search(input: String)
}
