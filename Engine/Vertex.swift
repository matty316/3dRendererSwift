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
}

let cubeVertices = [
    //Front face
    Vertex(position: [-0.5, -0.5, 0.5, 1.0], texCoords: [0.0, 0.0]),
    Vertex(position: [0.5, -0.5, 0.5, 1.0], texCoords: [1.0, 0.0]),
    Vertex(position: [0.5, 0.5, 0.5, 1.0], texCoords: [1.0, 1.0]),
    Vertex(position: [0.5, 0.5, 0.5, 1.0], texCoords: [1.0, 1.0]),
    Vertex(position: [-0.5, 0.5, 0.5, 1.0], texCoords: [0.0, 1.0]),
    Vertex(position: [-0.5, -0.5, 0.5, 1.0], texCoords: [0.0, 0.0]),
    
    //Back face
    Vertex(position: [0.5, -0.5, -0.5, 1.0], texCoords: [0.0, 0.0]),
    Vertex(position: [-0.5, -0.5, -0.5, 1.0], texCoords: [1.0, 0.0]),
    Vertex(position: [-0.5, 0.5, -0.5, 1.0], texCoords: [1.0, 1.0]),
    Vertex(position: [-0.5, 0.5, -0.5, 1.0], texCoords: [1.0, 1.0]),
    Vertex(position: [0.5, 0.5, -0.5, 1.0], texCoords: [0.0, 1.0]),
    Vertex(position: [0.5, -0.5, -0.5, 1.0], texCoords: [0.0, 0.0]),
    
    //Top face
    Vertex(position: [-0.5, 0.5, 0.5, 1.0], texCoords: [0.0, 0.0]),
    Vertex(position: [0.5, 0.5, 0.5, 1.0], texCoords: [1.0, 0.0]),
    Vertex(position: [0.5, 0.5, -0.5, 1.0], texCoords: [1.0, 1.0]),
    Vertex(position: [0.5, 0.5, -0.5, 1.0], texCoords: [1.0, 1.0]),
    Vertex(position: [-0.5, 0.5, -0.5, 1.0], texCoords: [0.0, 1.0]),
    Vertex(position: [-0.5, 0.5, 0.5, 1.0], texCoords: [0.0, 0.0]),
    
    //Bottom face
    Vertex(position: [-0.5, -0.5, -0.5, 1.0], texCoords: [0.0, 0.0]),
    Vertex(position: [0.5, -0.5, -0.5, 1.0], texCoords: [1.0, 0.0]),
    Vertex(position: [0.5, -0.5, 0.5, 1.0], texCoords: [1.0, 1.0]),
    Vertex(position: [0.5, -0.5, 0.5, 1.0], texCoords: [1.0, 1.0]),
    Vertex(position: [-0.5, -0.5, 0.5, 1.0], texCoords: [0.0, 1.0]),
    Vertex(position: [-0.5, -0.5, -0.5, 1.0], texCoords: [0.0, 0.0]),
    
    //Left face
    Vertex(position: [-0.5, -0.5, -0.5, 1.0], texCoords: [0.0, 0.0]),
    Vertex(position: [-0.5, -0.5, 0.5, 1.0], texCoords: [1.0, 0.0]),
    Vertex(position: [-0.5, 0.5, 0.5, 1.0], texCoords: [1.0, 1.0]),
    Vertex(position: [-0.5, 0.5, 0.5, 1.0], texCoords: [1.0, 1.0]),
    Vertex(position: [-0.5, 0.5, -0.5, 1.0], texCoords: [0.0, 1.0]),
    Vertex(position: [-0.5, -0.5, -0.5, 1.0], texCoords: [0.0, 0.0]),
    
    //Right face
    Vertex(position: [0.5, -0.5, 0.5, 1.0], texCoords: [0.0, 0.0]),
    Vertex(position: [0.5, -0.5, -0.5, 1.0], texCoords: [1.0, 0.0]),
    Vertex(position: [0.5, 0.5, -0.5, 1.0], texCoords: [1.0, 1.0]),
    Vertex(position: [0.5, 0.5, -0.5, 1.0], texCoords: [1.0, 1.0]),
    Vertex(position: [0.5, 0.5, 0.5, 1.0], texCoords: [0.0, 1.0]),
    Vertex(position: [0.5, -0.5, 0.5, 1.0], texCoords: [0.0, 0.0]),
]
