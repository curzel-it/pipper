//
//  AppState.swift
//  Pipper
//
//  Created by Federico Curzel on 28/07/22.
//

import Combine
import SwiftUI

class AppState: ObservableObject {
    
    @Published var isHovering = true
    @Published var userMessage: UserMessage?
    @Published var showHome = true
    @Published var showSearch = false
    @Published var showSettings = false
    @Published var navigationRequest: NavigationRequest = .urlString(urlString: "about:blank")
    
    let runtimeEvents = CurrentValueSubject<RuntimeEvent, Never>(.loading)
    
    lazy var webViewDelegate: WebViewDelegate = {
        WebViewDelegate(appState: self)
    }()
    
    lazy var windowManager: WindowManager = {
        WindowManager(appState: self)
    }()
}

enum RuntimeEvent {
    case loading
    case launching
    case closing
}
