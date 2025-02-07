//
//  Camera.swift
//  Engine
//
//  Created by matty on 2/7/25.
//

import simd
import MetalKit

struct Camera {
    var transformation: TransformationData!
    var pos = vector_float3(0, 0, 3)
    var front = vector_float3(0, 0, -1)
    var up = vector_float3(0, 1, 0)
    
    mutating func update(view: MTKView) {
        let translationMatrix = matrix4x4_translation(0, 0, -1.0)
        let angleInDegrees: Float = 0.0
        let angleInRadians = angleInDegrees * Float.pi / 180.0
        let rotationMatrix = matrix4x4_rotation(angleInRadians, [0.0, 1.0, 0.0])
        
        let modelMatrix = simd_mul(translationMatrix, rotationMatrix)
        
        let viewMatrix = matrix_look_at_right_hand(pos, pos + front, up)
        
        let aspectRatio = Float(view.frame.size.width / view.frame.size.height)
        let fov = 45.0 * (Float.pi / 180.0)
        let nearZ: Float = 0.1
        let farZ: Float = 100.0
        
        let perspectiveMatrix = matrix_perspective_right_hand(fov, aspectRatio, nearZ, farZ)
        
        self.transformation = TransformationData(modelMatrix: modelMatrix, viewMatrix: viewMatrix, perspectiveMatrix: perspectiveMatrix)
    }
}
