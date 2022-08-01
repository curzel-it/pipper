//
//  MouseHandler.swift
//  Pipper
//
//  Created by Federico Curzel on 31/07/22.
//

import SwiftUI

extension View {
    
    func onMouseDown(action: @escaping (NSEvent) -> Void) -> some View {
        ClickableRepresentable(
            content: { self },
            handler: MouseHandler(mouseDown: action)
        )
    }
    
    func onMouseDragged(action: @escaping (NSEvent) -> Void) -> some View {
        ClickableRepresentable(
            content: { self },
            handler: MouseHandler(mouseDragged: action)
        )
    }
    
    func onMouseEntered(action: @escaping (NSEvent) -> Void) -> some View {
        ClickableRepresentable(
            content: { self },
            handler: MouseHandler(mouseEntered: action)
        )
    }
    
    func onMouseExited(action: @escaping (NSEvent) -> Void) -> some View {
        ClickableRepresentable(
            content: { self },
            handler: MouseHandler(mouseExited: action)
        )
    }
    
    func onMouseMoved(action: @escaping (NSEvent) -> Void) -> some View {
        ClickableRepresentable(
            content: { self },
            handler: MouseHandler(mouseMoved: action)
        )
    }
    
    func onMouseUp(action: @escaping (NSEvent) -> Void) -> some View {
        ClickableRepresentable(
            content: { self },
            handler: MouseHandler(mouseUp: action)
        )
    }
    
    func onOtherMouseDown(action: @escaping (NSEvent) -> Void) -> some View {
        ClickableRepresentable(
            content: { self },
            handler: MouseHandler(otherMouseDown: action)
        )
    }
    
    func onOtherMouseDragged(action: @escaping (NSEvent) -> Void) -> some View {
        ClickableRepresentable(
            content: { self },
            handler: MouseHandler(otherMouseDragged: action)
        )
    }
    
    func onOtherMouseUp(action: @escaping (NSEvent) -> Void) -> some View {
        ClickableRepresentable(
            content: { self },
            handler: MouseHandler(otherMouseUp: action)
        )
    }
    
    func onRightMouseDown(action: @escaping (NSEvent) -> Void) -> some View {
        ClickableRepresentable(
            content: { self },
            handler: MouseHandler(rightMouseDown: action)
        )
    }
    
    func onRightMouseDragged(action: @escaping (NSEvent) -> Void) -> some View {
        ClickableRepresentable(
            content: { self },
            handler: MouseHandler(rightMouseDragged: action)
        )
    }
    
    func onRightMouseUp(action: @escaping (NSEvent) -> Void) -> some View {
        ClickableRepresentable(
            content: { self },
            handler: MouseHandler(rightMouseUp: action)
        )
    }
}

private struct MouseHandler {
    
    var mouseDown: ((NSEvent) -> Void)?
    var mouseDragged: ((NSEvent) -> Void)?
    var mouseEntered: ((NSEvent) -> Void)?
    var mouseExited: ((NSEvent) -> Void)?
    var mouseMoved: ((NSEvent) -> Void)?
    var mouseUp: ((NSEvent) -> Void)?
    var otherMouseDown: ((NSEvent) -> Void)?
    var otherMouseDragged: ((NSEvent) -> Void)?
    var otherMouseUp: ((NSEvent) -> Void)?
    var rightMouseDown: ((NSEvent) -> Void)?
    var rightMouseDragged: ((NSEvent) -> Void)?
    var rightMouseUp: ((NSEvent) -> Void)?
}

private struct ClickableRepresentable<Content: View>: NSViewRepresentable {
    
    let content: () -> Content
    let handler: MouseHandler
    
    func makeNSView(context: Context) -> some NSView {
        ProxyHost(
            handler: handler,
            rootView: AnyView(content())
        )
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        // ...
    }
}

private class ProxyHost: NSHostingView<AnyView> {
    
    let mouseHandler: MouseHandler
    
    init(handler: MouseHandler, rootView: AnyView) {
        mouseHandler = handler
        super.init(rootView: rootView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor required init(rootView: AnyView) {
        fatalError("init(rootView:) has not been implemented")
    }
    
    override func mouseDown(with event: NSEvent) {
        mouseHandler.mouseDown?(event)
        super.mouseDown(with: event)
    }
    
    override func mouseDragged(with event: NSEvent) {
        mouseHandler.mouseDragged?(event)
        super.mouseDragged(with: event)
    }
    
    override func mouseEntered(with event: NSEvent) {
        mouseHandler.mouseEntered?(event)
        super.mouseEntered(with: event)
    }
    
    override func mouseExited(with event: NSEvent) {
        mouseHandler.mouseExited?(event)
        super.mouseExited(with: event)
    }
    
    override func mouseMoved(with event: NSEvent) {
        mouseHandler.mouseMoved?(event)
        super.mouseMoved(with: event)
    }
    
    override func mouseUp(with event: NSEvent) {
        mouseHandler.mouseUp?(event)
        super.mouseUp(with: event)
    }
    
    override func otherMouseDown(with event: NSEvent) {
        mouseHandler.otherMouseDown?(event)
        super.otherMouseDown(with: event)
    }
    
    override func otherMouseDragged(with event: NSEvent) {
        mouseHandler.otherMouseDragged?(event)
        super.otherMouseDragged(with: event)
    }
    
    override func otherMouseUp(with event: NSEvent) {
        mouseHandler.otherMouseUp?(event)
        super.otherMouseUp(with: event)
    }
    
    override func rightMouseDown(with event: NSEvent) {
        mouseHandler.rightMouseDown?(event)
        super.rightMouseDown(with: event)
    }
    
    override func rightMouseDragged(with event: NSEvent) {
        mouseHandler.rightMouseDragged?(event)
        super.rightMouseDragged(with: event)
    }
    
    override func rightMouseUp(with event: NSEvent) {
        mouseHandler.rightMouseUp?(event)
        super.rightMouseUp(with: event)
    }
}
