//
//  WindowManager.swift
//  Pipper
//
//  Created by Federico Curzel on 28/07/22.
//

import Combine
import SwiftUI

class WindowManager: NSObject, NSWindowDelegate {
    
    private let appState: AppState
    private let globalState: GlobalState = .shared
    
    private var sizeSink: AnyCancellable?
    private var hoverSink: AnyCancellable?
    
    init(appState: AppState) {
        self.appState = appState
        super.init()
        globalState.runtimeEvents.send(.launching)
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
        sizeSink = globalState.$size.sink { size in
            window.setContentSize(size)
        }
    }
    
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        if globalState.size != frameSize {
            globalState.size = frameSize
        }
        return frameSize
    }
    
    func windowWillClose(_ notification: Notification) {
        globalState.runtimeEvents.send(.closing)
    }
}
