import Combine
import SwiftUI

class WindowManager: NSObject, NSWindowDelegate {
    private weak var window: NSWindow?
    private var disposables = Set<AnyCancellable>()
    
    @Inject private var appState: AppState
    @Inject private var runtimeEvents: RuntimeEvents
    
    override init() {
        super.init()
        runtimeEvents.send(.launching)
    }
    
    func miniaturize() {
        window?.miniaturize(nil)
    }
    
    func newWindow() {
        let controller = NSHostingController(rootView: ContentView())
        let window = NSWindow(contentViewController: controller)
        setup(window: window)
        window.show()
    }
    
    func resetAccessoryMode(enabled accessoryModeEnabled: Bool) {
        if accessoryModeEnabled {
            NSApp.setActivationPolicy(.accessory)
        } else {
            NSApp.setActivationPolicy(.regular)
        }
    }
    
    func setup(window: NSWindow) {
        self.window = window
        window.hasShadow = false
        window.backgroundColor = .clear
        window.collectionBehavior = .canJoinAllSpaces
        window.delegate = self
        window.setContentSize(appState.windowSize)
        window.styleMask = [.borderless, .miniaturizable, .resizable]
        window.isOpaque = false
        bindHovering()
    }
    
    func windowWillResize(_ sender: NSWindow, to newSize: NSSize) -> NSSize {
        appState.windowSize = newSize
        return newSize
    }
    
    func windowWillClose(_ notification: Notification) {
        runtimeEvents.send(.closing)
    }
    
    func windowDidBecomeKey(_ notification: Notification) {
        appState.showAdditionalInfo = true
    }
    
    func windowDidResignKey(_ notification: Notification) {
        appState.showAdditionalInfo = false
    }
                       
    private func bindHovering() {
        appState.$isHovering
            .sink { self.window?.level = $0 ? .floating : .normal }
            .store(in: &disposables)
    }
}
