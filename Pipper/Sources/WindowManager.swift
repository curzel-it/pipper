//
//  WindowManager.swift
//  Pipper
//
//  Created by Federico Curzel on 28/07/22.
//

import Combine
import SwiftUI

class WindowManager: NSObject, NSWindowDelegate {
        
    let appState = AppState.global
    
    private var sizeSink: AnyCancellable?
    private var hoverSink: AnyCancellable?
    
    override init() {
        super.init()
        appState.runtimeEvents.send(.launching)
    }
    
    func setup(window: NSWindow) {
        window.minSize = Size.i1b1w240
        window.collectionBehavior = .canJoinAllSpaces
        window.titlebarAppearsTransparent = true
        window.titlebarSeparatorStyle = .none
        window.delegate = self
        
        hoverSink = appState.$isHovering.sink { shouldHover in
            window.level = shouldHover ? .mainMenu : .normal
        }
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
    
    func windowWillClose(_ notification: Notification) {
        appState.runtimeEvents.send(.closing)
    }
}
