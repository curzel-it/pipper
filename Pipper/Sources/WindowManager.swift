//
//  WindowManager.swift
//  Pipper
//
//  Created by Federico Curzel on 28/07/22.
//

import Combine
import SwiftUI

class WindowManager: NSObject, NSWindowDelegate {
        
    let appState: AppState
    
    private var sizeSink: AnyCancellable?
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    func setup(window: NSWindow) {
        window.minSize = Size.i1b2w240
        window.level = .mainMenu
        window.collectionBehavior = .canJoinAllSpaces
        window.delegate = self
        
        sizeSink?.cancel()
        sizeSink = appState.$size.sink { size in
            window.setContentSize(size)
        }
    }
    
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        if appState.size != frameSize {
            appState.size = frameSize
        }
        return frameSize
    }
}
