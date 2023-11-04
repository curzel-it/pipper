import Foundation
import SwiftUI
import Schwifty

struct WindowMover: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        WindowMoverRepresentable()
            .frame(maxWidth: .infinity)
            .frame(height: 20)
    }
}

private struct WindowMoverRepresentable: NSViewRepresentable {
    @MainActor func makeNSView(context: Self.Context) -> WindowMoverView {
        let view = WindowMoverView()
        return view
    }
    
    @MainActor func updateNSView(_ nsView: WindowMoverView, context: Self.Context) {
        // ...
    }
}

private class WindowMoverView: NSView {
    @Inject private var windowManager: WindowManager
    
    override func mouseDragged(with event: NSEvent) {
        guard let window else { return }
        
        let position = window.frame.origin
            .offset(x: event.deltaX)
            .offset(y: -event.deltaY)
        
        window.setFrame(CGRect(origin: position, size: window.frame.size), display: true, animate: false)
    }
}
