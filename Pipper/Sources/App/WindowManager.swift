import Combine
import SwiftUI

class WindowManager: NSObject, NSWindowDelegate {
    private let appState: AppState
    private var hoverSink: AnyCancellable?
    
    init(appState: AppState) {
        self.appState = appState
        super.init()
        appState.runtimeEvents.send(.launching)
    }
    
    func setup(window: NSWindow) {
        window.collectionBehavior = .canJoinAllSpaces
        window.delegate = self
        window.setContentSize(appState.windowSize)
        
        hoverSink = appState.$isHovering.sink { shouldHover in
            window.level = shouldHover ? .mainMenu : .normal
        }
    }
    
    func windowWillResize(_ sender: NSWindow, to newSize: NSSize) -> NSSize {
        appState.windowSize = newSize
        return newSize
    }
    
    func windowWillClose(_ notification: Notification) {
        appState.runtimeEvents.send(.closing)
    }
    
    func windowDidBecomeKey(_ notification: Notification) {
        appState.showAdditionalInfo = true
    }
    
    func windowDidResignKey(_ notification: Notification) {
        appState.showAdditionalInfo = false
    }
}
