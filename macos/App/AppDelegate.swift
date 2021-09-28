//
//  AppDelegate.swift
//  App
//
//  Created by Federico Curzel on 15/04/2020.
//  Copyright © 2020 Federico Curzel. All rights reserved.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let viewModel = ViewModel.shared
    
    // MARK: - Menus
    
    @IBAction func onMenuItemSelected(_ item: NSMenuItem) {
        viewModel.onMenuItemSelected(item.identifier?.rawValue)
    }
}
