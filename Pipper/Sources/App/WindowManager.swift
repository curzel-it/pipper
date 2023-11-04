import Combine
import SwiftUI
import Schwifty

class WindowManager: NSObject, NSWindowDelegate {
    private weak var window: PipperWindow?
    private var disposables = Set<AnyCancellable>()
    
    @Inject private var appState: AppState
    @Inject private var runtimeEvents: RuntimeEvents
    
    private let tag = "WindowManager"
    
    override init() {
        super.init()
        runtimeEvents.send(.launching)
    }
    
    func miniaturize() {
        window?.miniaturize(nil)
    }
    
    func newWindow() {
        let controller = NSHostingController(rootView: ContentView())
        let window = PipperWindow(contentViewController: controller)
        self.window = window
        window.delegate = self
        window.setup()
        window.show()
    }
    
    func resetAccessoryMode(enabled accessoryModeEnabled: Bool) {
        if accessoryModeEnabled {
            NSApp.setActivationPolicy(.accessory)
        } else {
            NSApp.setActivationPolicy(.regular)
        }
    }
    
    func windowWillResize(_ sender: NSWindow, to newSize: NSSize) -> NSSize {
        appState.windowSize = newSize
        return newSize
    }
    
    func windowWillClose(_ notification: Notification) {
        runtimeEvents.send(.closing)
    }
    
    func windowDidBecomeKey(_ notification: Notification) {
        Logger.debug(tag, "windowDidBecomeKey")
    }
    
    func windowDidResignKey(_ notification: Notification) {
        Logger.debug(tag, "windowDidResignKey")
    }
    
    func windowDidBecomeMain(_ notification: Notification) {
        Logger.debug(tag, "windowDidBecomeMain")
    }
    
    func windowDidResignMain(_ notification: Notification) {
        Logger.debug(tag, "windowDidResignMain")
    }
}

class PipperWindow: NSWindow {
    @Inject private var appState: AppState
    
    private var disposables = Set<AnyCancellable>()
    
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
    
    func setup() {
        hasShadow = false
        backgroundColor = .clear
        collectionBehavior = .canJoinAllSpaces
        setContentSize(appState.windowSize)
        styleMask = [.borderless, .miniaturizable, .resizable]
        isOpaque = false
        bindHovering()
    }
                       
    private func bindHovering() {
        appState.$isHovering
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldHover in
                self?.level = shouldHover ? .floating : .normal
            }
            .store(in: &disposables)
    }
}
