//
//  ViewModel.swift
//  Pipper
//
//  Created by CURZEL Federico on 28/09/21.
//  Copyright © 2021 Federico Curzel. All rights reserved.
//

import Cocoa
import RxRelay

class ViewModel {
    
    static let shared = ViewModel()
    
    let navigationRequest = BehaviorRelay<NavigationRequest>(value: .homepage)
    
    let initialWindowFrame: CGRect
    
    // MARK: - Init
    
    init() {
        if let latestFrameString = UserDefaults.standard.string(forKey: kInitialWindowFrame) {
            self.initialWindowFrame = NSRectFromString(latestFrameString)
        } else {
            self.initialWindowFrame = CGRect(
                origin: CGPoint.zero,
                size: CGSize(width: 320, height: 480)
            )
        }        
    }
    
    // MARK: - Lifecycle
    
    func viewDidAppear() {
        if let url = urlFromCommandLineArgs() {
            navigationRequest.accept(.url(url))
        } else {
            navigationRequest.accept(.homepage)
        }
    }
    
    // MARK: - Window
    
    func windowFrameChanged(to frame: CGRect) {
        UserDefaults.standard.set(
            NSStringFromRect(frame),
            forKey: kInitialWindowFrame
        )
    }
    
    // MARK: - Menu
    
    func onMenuItemSelected(_ id: String?) {
        switch id {
            
        case "reload":
            navigationRequest.accept(.reload)
            
        case "visit_copied_link":
            guard let items = NSPasteboard.general.pasteboardItems else { return }
            guard let urlString = items.first?.string(forType: .string) else { return }
            guard let url = URL(string: urlString) else { return }
            navigationRequest.accept(.url(url))
            
        default:
            print("[ViewModel] Unknown menu item selected: \(id ?? "n/a")")
        }
    }
    
    // MARK: - Command Line
    
    private func urlFromCommandLineArgs() -> URL? {
        return CommandLine.arguments
            .filter { $0.starts(with: "http") }
            .compactMap { URL(string: $0) }
            .first
    }
}

let kInitialWindowFrame = "kInitialWindowFrame"
