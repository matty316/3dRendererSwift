//
//  Renderer.swift
//  Engine
//
//  Created by matty on 2/7/25.
//

import MetalKit
import SwiftUI
import GameController

class Renderer: NSObject, MTKViewDelegate {
    let device: MTLDevice
    let depthState: MTLDepthStencilState
    let pipelineState: MTLRenderPipelineState
    let commandQueue: MTLCommandQueue
    let vertexBuffer: MTLBuffer
    var viewportSize = CGSize()
    var zoom: Float = 0.0
    var cam = Camera()
    var keysPressed = [GCKeyCode: Bool]()
    var mouseDelta: (x: Float, y: Float) = (0.0, 0.0)
    var pitch: Float = 0.0
    var yaw: Float = -90.0
    
    var lastDelta: (x: Float, y: Float) = (0.0, 0.0)
    
    override init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Unable to get GPU")
        }
        
        self.device = device
        
        guard let library = device.makeDefaultLibrary() else {
            fatalError("cannot get library")
        }
        
        let vertexFunc = library.makeFunction(name: "vertexShader")
        let fragmentFunc = library.makeFunction(name: "fragmentShader")
        
        let depthDescriptor = MTLDepthStencilDescriptor()
        depthDescriptor.depthCompareFunction = .lessEqual
        depthDescriptor.isDepthWriteEnabled = true
        
        guard let depthState = device.makeDepthStencilState(descriptor: depthDescriptor) else {
            fatalError("cannot get depth state")
        }
        
        self.depthState = depthState
        
        guard let vertexBuffer = device.makeBuffer(bytes: cubeVertices, length: MemoryLayout<Vertex>.stride * cubeVertices.count) else {
            fatalError("cannot make vertex buffer")
        }
        self.vertexBuffer = vertexBuffer
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.label = "Render Pipeline"
        pipelineStateDescriptor.vertexFunction = vertexFunc
        pipelineStateDescriptor.fragmentFunction = fragmentFunc
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        guard let pipelineState = try? device.makeRenderPipelineState(descriptor: pipelineStateDescriptor) else {
            fatalError("cannot make pipeline")
        }
        
        self.pipelineState = pipelineState
        
        guard let commandQueue = device.makeCommandQueue() else {
            fatalError("cannot make command queue")
        }
        
        self.commandQueue = commandQueue
        
        super.init()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        viewportSize.width = size.width
        viewportSize.height = size.height
    }
    
    func processInput() {
        let camSpeed: Float = 0.1
        if keysPressed[.keyW] == true {
            cam.pos += camSpeed * cam.front
        }
        if keysPressed[.keyS] == true {
            cam.pos -= camSpeed * cam.front
        }
        if keysPressed[.keyA] == true {
            cam.pos -= simd_normalize(simd_cross(cam.front, cam.up)) * camSpeed
        }
        if keysPressed[.keyD] == true {
            cam.pos += simd_normalize(simd_cross(cam.front, cam.up)) * camSpeed
        }
        if keysPressed[.escape] == true {
            exit(0)
        }
        
        let delta = lastDelta
        
        if abs(mouseDelta.x - delta.x) + abs(mouseDelta.y - delta.y) > 0.0001 {
            var xOffset = mouseDelta.x
            var yOffset = mouseDelta.y
            let sensitivity: Float = 0.1
            xOffset *= sensitivity
            yOffset *= sensitivity
            
            yaw += xOffset
            pitch += yOffset
            
            if pitch > 89.0 {
                pitch = 89.0
            }
            if pitch < -89.0 {
                pitch = -89.0
            }
            
            var direction = SIMD3<Float>()
            direction.x = cos(radians(yaw)) * cos(radians(pitch))
            direction.y = sin(radians(pitch))
            direction.z = sin(radians(yaw)) * cos(radians(pitch))
            cam.front = simd_normalize(direction)
            lastDelta = mouseDelta
        }
    }
    
    func radians(_ degrees: Float) -> Float {
        return degrees * Float.pi / 180.0
    }
    
    func draw(in view: MTKView) {
        processInput()
        
        let loader = MTKTextureLoader(device: device)
        let texture = try! loader.newTexture(name: "mc_grass", scaleFactor: 1.0, bundle: .main, options: [.origin: MTKTextureLoader.Origin.flippedVertically])
        
        guard let renderPassDescriptor = view.currentRenderPassDescriptor, let commandBuffer = commandQueue.makeCommandBuffer() else {
            return
        }
        commandBuffer.label = "MyCommand"
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        renderEncoder.label = "MyRenderEndcoder"
        
        renderEncoder.setDepthStencilState(depthState)
        
        renderEncoder.setViewport(MTLViewport(originX: 0.0,
                                              originY: 0.0,
                                              width: viewportSize.width,
                                              height: viewportSize.height,
                                              znear: 0.0,
                                              zfar: 1.0))
        
        renderEncoder.setRenderPipelineState(pipelineState)
        
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.setFragmentTexture(texture, index: 0)
        
        renderEncoder.setFrontFacing(.counterClockwise)
        renderEncoder.setCullMode(.back)
        
        let chunkSize = 16
        for i in 0..<chunkSize {
            for j in 0..<chunkSize {
                for z in 0..<chunkSize {
                    cam.update(view: view, position: [Float(1 * i), Float(j * 1), Float(-1 * z)])
                    guard let transformationBuffer = device.makeBuffer(bytes: &cam.transformation, length: MemoryLayout<TransformationData>.stride) else {
                        return
                    }
                    renderEncoder.setVertexBuffer(transformationBuffer, offset: 0, index: 1)
                    
                    renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 36)
                }
            }
        }
        
        renderEncoder.endEncoding()
        if let currentDrawable = view.currentDrawable {
            commandBuffer.present(currentDrawable)
        }
        commandBuffer.commit()
    }
}
