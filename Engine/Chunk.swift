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
    static let noise: GKNoise = {
        let source = GKPerlinNoiseSource()
        source.frequency = 0.5
        source.persistence = 0.9
        return GKNoise(source)
    }()
    
    var isLoaded = false
    
    init(origin: SIMD2<Double>) {
        self.origin = origin
        for i in 0..<chunkSize {
            self.blocks.append([[Block]]())
            for j in 0..<chunkSize {
                self.blocks[i].append([Block]())
                for _ in 0..<chunkSize {
                    self.blocks[i][j].append(Block(blockType: .grass, isActive: false))
                }
            }
        }
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
    
    mutating func isBlockHidden(_ x: Int, _ y: Int, _ z: Int) -> Bool {
            let blockLeft = x > 0 && blocks[x - 1][y][z].isActive
            let blockRight = x < chunkSize - 1 && blocks[x + 1][y][z].isActive
            let blockBehind = z > 0 && blocks[x][y][z - 1].isActive
            let blockFront = z < chunkSize - 1 && blocks[x][y][z + 1].isActive
            let blockAbove = y > 0 && blocks[x][y - 1][z].isActive
            let blockBelow = y < chunkSize - 1 && blocks[x][y + 1][z].isActive
            
            return blockLeft && blockRight && blockBehind && blockFront && blockAbove && blockBelow
    }
    
    mutating func render(cam: inout Camera, renderEncoder: MTLRenderCommandEncoder, view: MTKView, device: MTLDevice) {
        guard isLoaded else { return }
        for x in 0..<chunkSize {
            for y in 0..<chunkSize {
                for z in 0..<chunkSize {
                    let block = blocks[x][y][z]
                    guard block.isActive && !isBlockHidden(x, y, z) else { continue }
                    let x = Float(x) + Float(origin.x * Double(chunkSize))
                    let y = Float(y)
                    let z = Float(-1 * z) + Float(origin.y * Double(chunkSize))
                    cam.update(view: view, position: [x, y, z])
                    guard let transformationBuffer = device.makeBuffer(bytes: &cam.transformation, length: MemoryLayout<TransformationData>.stride) else {
                        return
                    }
                    renderEncoder.setVertexBuffer(transformationBuffer, offset: 0, index: 1)
                    
                    renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 36)
                }
            }
        }
    }
}
