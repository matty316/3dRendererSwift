//
//  Vertex.swift
//  Engine
//
//  Created by matty on 2/7/25.
//

import simd

struct Vertex {
    let position: SIMD4<Float>
    let texCoords: SIMD2<Float>
    let normal: SIMD3<Float>
    let top: Bool
    
    init(position: SIMD4<Float>, texCoords: SIMD2<Float>, normal: SIMD3<Float>, top: Bool = false) {
        self.position = position
        self.texCoords = texCoords
        self.normal = normal
        self.top = top
    }
}

let cubeVertices = (
    //Front face
    front: [
        Vertex(position: [-0.5, -0.5, 0.5, 1.0], texCoords: [0.0, 0.0], normal: [0.0, 0.0, 1.0]),
        Vertex(position: [0.5, -0.5, 0.5, 1.0], texCoords: [1.0, 0.0], normal: [0.0, 0.0, 1.0]),
        Vertex(position: [0.5, 0.5, 0.5, 1.0], texCoords: [1.0, 1.0], normal: [0.0, 0.0, 1.0]),
        Vertex(position: [0.5, 0.5, 0.5, 1.0], texCoords: [1.0, 1.0], normal: [0.0, 0.0, 1.0]),
        Vertex(position: [-0.5, 0.5, 0.5, 1.0], texCoords: [0.0, 1.0], normal: [0.0, 0.0, 1.0]),
        Vertex(position: [-0.5, -0.5, 0.5, 1.0], texCoords: [0.0, 0.0], normal: [0.0, 0.0, 1.0]),
    ],
    //Back face
    back: [
        Vertex(position: [0.5, -0.5, -0.5, 1.0], texCoords: [0.0, 0.0], normal: [0.0, 0.0, -1.0]),
        Vertex(position: [-0.5, -0.5, -0.5, 1.0], texCoords: [1.0, 0.0], normal: [0.0, 0.0, -1.0]),
        Vertex(position: [-0.5, 0.5, -0.5, 1.0], texCoords: [1.0, 1.0], normal: [0.0, 0.0, -1.0]),
        Vertex(position: [-0.5, 0.5, -0.5, 1.0], texCoords: [1.0, 1.0], normal: [0.0, 0.0, -1.0]),
        Vertex(position: [0.5, 0.5, -0.5, 1.0], texCoords: [0.0, 1.0], normal: [0.0, 0.0, -1.0]),
        Vertex(position: [0.5, -0.5, -0.5, 1.0], texCoords: [0.0, 0.0], normal: [0.0, 0.0, -1.0]),
    ],
    //Top face
    top: [
        Vertex(position: [-0.5, 0.5, 0.5, 1.0], texCoords: [0.0, 0.0], normal: [0.0, 1.0, 0.0], top: true),
        Vertex(position: [0.5, 0.5, 0.5, 1.0], texCoords: [1.0, 0.0], normal: [0.0, 1.0, 0.0], top: true),
        Vertex(position: [0.5, 0.5, -0.5, 1.0], texCoords: [1.0, 1.0], normal: [0.0, 1.0, 0.0], top: true),
        Vertex(position: [0.5, 0.5, -0.5, 1.0], texCoords: [1.0, 1.0], normal: [0.0, 1.0, 0.0], top: true),
        Vertex(position: [-0.5, 0.5, -0.5, 1.0], texCoords: [0.0, 1.0], normal: [0.0, 1.0, 0.0], top: true),
        Vertex(position: [-0.5, 0.5, 0.5, 1.0], texCoords: [0.0, 0.0], normal: [0.0, 1.0, 0.0], top: true),
    ],
    //Bottom face
    bottom: [
        Vertex(position: [-0.5, -0.5, -0.5, 1.0], texCoords: [0.0, 0.0], normal: [0.0, -1.0, 0.0]),
        Vertex(position: [0.5, -0.5, -0.5, 1.0], texCoords: [1.0, 0.0], normal: [0.0, -1.0, 0.0]),
        Vertex(position: [0.5, -0.5, 0.5, 1.0], texCoords: [1.0, 1.0], normal: [0.0, -1.0, 0.0]),
        Vertex(position: [0.5, -0.5, 0.5, 1.0], texCoords: [1.0, 1.0], normal: [0.0, -1.0, 0.0]),
        Vertex(position: [-0.5, -0.5, 0.5, 1.0], texCoords: [0.0, 1.0], normal: [0.0, -1.0, 0.0]),
        Vertex(position: [-0.5, -0.5, -0.5, 1.0], texCoords: [0.0, 0.0], normal: [0.0, -1.0, 0.0]),
    ],
    
    //Left face
    left: [
        Vertex(position: [-0.5, -0.5, -0.5, 1.0], texCoords: [0.0, 0.0], normal: [-1.0, 0.0, 0.0]),
        Vertex(position: [-0.5, -0.5, 0.5, 1.0], texCoords: [1.0, 0.0], normal: [-1.0, 0.0, 0.0]),
        Vertex(position: [-0.5, 0.5, 0.5, 1.0], texCoords: [1.0, 1.0], normal: [-1.0, 0.0, 0.0]),
        Vertex(position: [-0.5, 0.5, 0.5, 1.0], texCoords: [1.0, 1.0], normal: [-1.0, 0.0, 0.0]),
        Vertex(position: [-0.5, 0.5, -0.5, 1.0], texCoords: [0.0, 1.0], normal: [-1.0, 0.0, 0.0]),
        Vertex(position: [-0.5, -0.5, -0.5, 1.0], texCoords: [0.0, 0.0], normal: [-1.0, 0.0, 0.0]),
    ],
    
    //Right face
    right: [
        Vertex(position: [0.5, -0.5, 0.5, 1.0], texCoords: [0.0, 0.0], normal: [1.0, 0.0, 0.0]),
        Vertex(position: [0.5, -0.5, -0.5, 1.0], texCoords: [1.0, 0.0], normal: [1.0, 0.0, 0.0]),
        Vertex(position: [0.5, 0.5, -0.5, 1.0], texCoords: [1.0, 1.0], normal: [1.0, 0.0, 0.0]),
        Vertex(position: [0.5, 0.5, -0.5, 1.0], texCoords: [1.0, 1.0], normal: [1.0, 0.0, 0.0]),
        Vertex(position: [0.5, 0.5, 0.5, 1.0], texCoords: [0.0, 1.0], normal: [1.0, 0.0, 0.0]),
        Vertex(position: [0.5, -0.5, 0.5, 1.0], texCoords: [0.0, 0.0], normal: [1.0, 0.0, 0.0]),
    ]
)
