//
//  Chunk.swift
//  Engine
//
//  Created by matty on 2/8/25.
//

import MetalKit
import GameplayKit

struct Chunk {
    var blocks = [[[Block]]]()
    let chunkSize = 16
    let origin: SIMD2<Double>
    var vertices = [[[[Vertex]]]]()
    static let noise: GKNoise = {
        let source = GKPerlinNoiseSource()
        source.frequency = 0.5
        source.persistence = 0.9
        return GKNoise(source)
    }()
    
    var drawCounter = 0
    
    var isLoaded: Bool
    var verts = [Vertex]()
    var transformations = [TransformationData]()
    
    init(origin: SIMD2<Double>) {
        self.origin = origin
        for i in 0..<chunkSize {
            self.blocks.append([[Block]]())
            self.vertices.append([[[Vertex]]]())
            for j in 0..<chunkSize {
                self.blocks[i].append([Block]())
                self.vertices[i].append([[Vertex]]())
                for _ in 0..<chunkSize {
                    self.blocks[i][j].append(Block(blockType: .grass, isActive: false))
                    self.vertices[i][j].append([Vertex]())
                }
            }
        }
        self.isLoaded = false
    }
    
    func getNoiseMap() -> GKNoiseMap {
        let size = vector2(0.2, 0.2)
        let origin = origin
        let sampleCount = vector2(Int32(chunkSize), Int32(chunkSize))

        return GKNoiseMap(Self.noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
    }

    mutating func setupSphere() {
        for z in 0..<chunkSize {
            for y in 0..<chunkSize {
                for x in 0..<chunkSize {
                    let a = (x - chunkSize / 2) * (x - chunkSize / 2)
                    let b = (y - chunkSize / 2) * (y - chunkSize / 2)
                    let c = (z - chunkSize / 2) * (z - chunkSize / 2)
                    let d = chunkSize / 2
                    if sqrt(Double(a + b + c)) <= Double(d) {
                        blocks[x][y][z].isActive = true
                    }
                }
            }
        }
    }
    
    func height(noiseValue: Float) -> Int {
        let positiveVal = (noiseValue + 1.0) / 2.0
        
        let height = positiveVal * Float(chunkSize)
        return Int(height)
    }
    
    mutating func generateTerrain() {
        guard !isLoaded else { return }
        print("Called generate terrain")
        let noiseMap = getNoiseMap()
        for x in 0..<chunkSize {
            for z in 0..<chunkSize {
                let noiseValue = noiseMap.value(at: [Int32(x+1), Int32(z+1)])
                let height = height(noiseValue: noiseValue)
                for y in 0..<height {
                    blocks[x][y][z].isActive = true
                }
            }
        }
    }
    
    mutating func removeInternalBlocks() {
        guard !isLoaded else { return }
        print("Called remove blocks")
        let temp = blocks
        for x in 0..<chunkSize {
            for y in 0..<chunkSize {
                for z in 0..<chunkSize {
                    guard blocks[x][y][z].isActive else { continue }
                    let blockLeft = x > 0 && temp[x - 1][y][z].isActive
                    let blockRight = x < chunkSize - 1 && temp[x + 1][y][z].isActive
                    let blockBehind = z > 0 && temp[x][y][z - 1].isActive
                    let blockFront = z < chunkSize - 1 && temp[x][y][z + 1].isActive
                    let blockAbove = y < chunkSize - 1 && temp[x][y + 1][z].isActive
                    let blockBelow = y > 0 && temp[x][y - 1][z].isActive
                    
                    if blockLeft && blockRight && blockBehind && blockFront && blockAbove && blockBelow {
                        blocks[x][y][z].isActive = false
                    }
                }
            }
        }
    }
    
    mutating func createVertices() {
        guard !isLoaded else { return }
        print("Called create vertices")
        let temp = blocks

        for x in 0..<chunkSize {
            for y in 0..<chunkSize {
                for z in 0..<chunkSize {
                    guard blocks[x][y][z].isActive else {
                        continue
                    }
                    var verts = vertices[x][y][z]
                    
                    let blockLeft = x > 0 && temp[x - 1][y][z].isActive
                    let blockRight = x < chunkSize - 1 && temp[x + 1][y][z].isActive
                    let blockBehind = z < chunkSize - 1 && temp[x][y][z + 1].isActive
                    let blockFront = z > 0 && temp[x][y][z - 1].isActive
                    let blockAbove = y < chunkSize - 1 && temp[x][y + 1][z].isActive
                    let blockBelow = y > 0 && temp[x][y - 1][z].isActive
                    
                    if blockLeft && blockRight && blockBehind && blockFront && blockAbove && blockBelow {
                        blocks[x][y][z].isActive = false
                        continue
                    }
                    
                    if !blockLeft {
                        verts.append(contentsOf: cubeVertices.left)
                    }
                    if !blockRight {
                        verts.append(contentsOf: cubeVertices.right)
                    }
                    if !blockBehind {
                        verts.append(contentsOf: cubeVertices.back)
                    }
                    if !blockFront {
                        verts.append(contentsOf: cubeVertices.front)
                    }
                    if !blockAbove {
                        verts.append(contentsOf: cubeVertices.top)
                    }
                    if !blockBelow {
                        verts.append(contentsOf: cubeVertices.bottom)
                    }
                   
                    if !verts.isEmpty {
                        vertices[x][y][z].append(contentsOf: verts)
                    }
                }
            }
        }
    }
    
    mutating func setCamera(cam: Camera, width: Float, height: Float, x: Int, y: Int, z: Int) {
        let block = blocks[x][y][z]
        guard block.isActive else { return }
        let vertex = vertices[x][y][z]
        guard !vertex.isEmpty else { return }
    
        verts.append(contentsOf: vertex)
        
        let x = Float(x) + Float(origin.x * Double(chunkSize))
        let y = Float(y)
        let z = Float(-1 * z) + Float(origin.y * Double(chunkSize))
        cam.update(width: width, height: height, position: [x, y, z])
        
        vertex.forEach { _ in
            transformations.append(cam.transformation)
        }
    }
    
    mutating func render(cam: Camera, renderEncoder: MTLRenderCommandEncoder, width: Float, height: Float, device: MTLDevice) {
        transformations.removeAll()
        for x in 0..<chunkSize {
            for y in 0..<chunkSize {
                for z in 0..<chunkSize {
                    setCamera(cam: cam, width: width, height: height, x: x, y: y, z: z)
                }
            }
        }

        print(verts.count)
        print(transformations.count)
        guard let vertexBuffer = device.makeBuffer(bytes: verts, length: MemoryLayout<Vertex>.stride * verts.count) else {
            return
        }
        
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        guard let transformationBuffer = device.makeBuffer(bytes: transformations, length: MemoryLayout<TransformationData>.stride * transformations.count) else {
            return
        }
        
        renderEncoder.setVertexBuffer(transformationBuffer, offset: 0, index: 1)
        
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: verts.count)
    }
}
