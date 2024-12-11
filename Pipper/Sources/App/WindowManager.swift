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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.checkAndShowGameAlert()
        }
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
    
    private func checkAndShowGameAlert() {
        guard !UserDefaults.standard.bool(forKey: kSneakBitAsked) else { return }
        guard #available(macOS 14.0, *) else { return }
        let currentDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        guard currentDate.year == 2025, (currentDate.month ?? 0) < 2 else { return }
        
        UserDefaults.standard.set(true, forKey: kSneakBitAsked)
        
        let alert = NSAlert()
        alert.messageText = "I made a videogame!"
        alert.informativeText = "Do you want to check it out?\nIt's available for Windows, macOS, iOS, and Android.\n\nPs. Sorry for the interruption, this is a one time thing!"
        
        if let icon = NSImage(named: "sneakbit") {
            alert.icon = icon
        }
        
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Check it Out")
        alert.addButton(withTitle: "Maybe Later")
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            if let url = URL(string: "https://curzel.it/sneakbit") {
                NSWorkspace.shared.open(url)
            }
        }
        
        alert.runModal()
    }
}

private let kSneakBitAsked = "kSneakBitAsked1"

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
