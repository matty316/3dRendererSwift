//
//  MetalView.swift
//  Engine
//
//  Created by matty on 2/7/25.
//

import MetalKit
import SwiftUI

struct MetalView {
    @Binding var angle: Double
    @State var renderer = Renderer()
    
    func setupView() -> MTKView {
        let view = MTKView()
        view.delegate = renderer
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
        return view
    }
}

#if os(iOS)
extension MetalView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        setupView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
#elseif os(macOS)
extension MetalView: NSViewRepresentable {
    func makeNSView(context: Context) -> some NSView {
        setupView()
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        renderer.angle = Float(angle)
    }
}
#endif
