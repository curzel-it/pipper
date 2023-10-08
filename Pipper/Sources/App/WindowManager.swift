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
        bindTitleBarVisibility()
    }
    
    func setup(window: NSWindow) {
        self.window = window
        window.collectionBehavior = .canJoinAllSpaces
        window.delegate = self
        window.setContentSize(appState.windowSize)
        window.toolbar(visible: true)
        bindHovering()
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
    
    private func bindTitleBarVisibility() {
        appState.$showTitleBar
            .sink { [weak self] showTitleBar in
                let withTitle: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable]
                self?.window?.styleMask = showTitleBar ? withTitle : [.borderless]
            }
            .store(in: &disposables)
    }
                       
    private func bindHovering() {
        appState.$isHovering
            .sink { self.window?.level = $0 ? .floating : .normal }
            .store(in: &disposables)
    }
}

private extension NSWindow {
    func toolbar(visible: Bool) {
        let currentFrame = frame
        if visible {
            setToolbarVisible()
        } else {
            setToolbarInvisible()
        }
        
        setFrame(currentFrame, display: true)
        Task { @MainActor in
            setFrame(currentFrame, display: true)
        }
    }
    
    private func setToolbarVisible() {
        styleMask = [.titled, .closable, .miniaturizable, .resizable]
    }
    
    private func setToolbarInvisible() {
        styleMask = [.borderless]
    }
}
