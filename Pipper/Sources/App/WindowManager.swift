import Combine
import SwiftUI
import WindowsDetector

class WindowManager: NSObject, NSWindowDelegate {
    private let windowsDetector = WindowsDetectionService()
    private weak var window: NSWindow?
    private let appState: AppState
    private var disposables = Set<AnyCancellable>()
    
    init(appState: AppState) {
        self.appState = appState
        super.init()
        appState.runtimeEvents.send(.launching)
    }
    
    func setup(window: NSWindow) {
        self.window = window
        window.collectionBehavior = .canJoinAllSpaces
        window.delegate = self
        window.setContentSize(appState.windowSize)
        bindHovering()
    }
                       
    private func bindHovering() {
        appState.$isHovering
            .sink { self.window?.level = $0 ? .floating : .normal }
            .store(in: &disposables)
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
