//
//  AppDelegate.swift
//  App
//
//  Created by Federico Curzel on 15/04/2020.
//  Copyright © 2020 Federico Curzel. All rights reserved.
//

import Cocoa
import RxRelay

@main
class AppDelegate: NSObject, NSApplicationDelegate {
        
    static let navigationRequest = BehaviorRelay<NavigationRequest>(value: .homepage)
    
    // MARK: - Command Line Args
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let url = urlFromCommandLineArgs() {
            AppDelegate.navigationRequest.accept(.url(url))
        } else {
            AppDelegate.navigationRequest.accept(.homepage)
        }
    }
    
    private func urlFromCommandLineArgs() -> URL? {
        return CommandLine.arguments
            .filter { $0.starts(with: "http") }
            .compactMap { URL(string: $0) }
            .first
    }
    
    // MARK: - Menus
    
    @IBAction func navigateTo(_ sender: Any) {
        // TODO: Open up some text field and let user type in an URL.
    }
    
    @IBAction func visitCopiedLink(_ sender: Any) {
        guard let items = NSPasteboard.general.pasteboardItems else { return }
        guard let urlString = items.first?.string(forType: .string) else { return }
        guard let url = URL(string: urlString) else { return }
        AppDelegate.navigationRequest.accept(.url(url))
    }
    
    @IBAction func reloadPage(_ sender: Any) {
        AppDelegate.navigationRequest.accept(.reload)
    }
}

let kReloadRequest = "kReloadRequest"
