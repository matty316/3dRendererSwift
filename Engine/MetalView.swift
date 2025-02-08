//
//  MetalView.swift
//  Engine
//
//  Created by matty on 2/7/25.
//

import MetalKit
import SwiftUI
import GameController

struct MetalView {
    @State var angle: Double = 0.0
    @State var zoom: Double = 1.0
    @State var renderer = Renderer()
    @State var keysPressed = [GCKeyCode: Bool]()
    
    func setupView() -> MTKView {
        let view = MTKView()
        view.preferredFramesPerSecond = 60 
        view.enableSetNeedsDisplay = true
        
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Unable to get a GPU")
        }
        
        view.device = device
        view.framebufferOnly = false
        view.drawableSize = view.frame.size
        view.depthStencilPixelFormat = .depth32Float
        view.isPaused = false
        view.delegate = renderer
        
        NotificationCenter.default.addObserver(forName: Notification.Name.GCKeyboardDidConnect, object: nil, queue: nil) { notification in
            let keyboard = notification.object as? GCKeyboard
            keyboard?.keyboardInput?.keyChangedHandler = { _, _, code, pressed in
                renderer.keysPressed[code] = pressed
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.GCMouseDidConnect, object: nil, queue: nil) { notification in
            let mouse = notification.object as? GCMouse
            
            mouse?.mouseInput?.mouseMovedHandler = { _, deltaX, deltaY in
                renderer.mouseDelta = (deltaX, deltaY)
            }
        }
        
        return view
    }
    
    func update() {
    }
}

#if os(iOS)
extension MetalView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        setupView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        update()
    }
}
#elseif os(macOS)
extension MetalView: NSViewRepresentable {
    func makeNSView(context: Context) -> some NSView {
        setupView()
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        update()
    }
}
#endif
