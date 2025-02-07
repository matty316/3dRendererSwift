//
//  Camera.swift
//  Engine
//
//  Created by matty on 2/7/25.
//

import simd
import MetalKit

struct Camera {
    var transformation: TransformationData
    
    init(view: MTKView, angle: Float) {
        let translationMatrix = matrix4x4_translation(tx: 0, ty: 0, tz: -1.0)
        let angleInDegrees: Float = angle
        let angleInRadians = angleInDegrees * Float.pi / 180.0
        let rotationMatrix = matrix4x4_rotation(radians: angleInRadians, axis: [0.0, 1.0, 0.0])
        
        let modelMatrix = simd_mul(translationMatrix, rotationMatrix)
        
        let R = SIMD3<Float>(1, 0, 0)
        let U = SIMD3<Float>(0, 1, 0)
        let F = SIMD3<Float>(0, 0, -1)
        let P = SIMD3<Float>(0, 0, 1)
        
        let viewMatrix = matrix_make_rows(m00: R.x, m10: R.y, m20: R.z, m30: dot(-R, P),
                                          m01: U.x, m11: U.y, m21: U.z, m31: dot(-U, P),
                                          m02: -F.x, m12: -F.y, m22: -F.z, m32: dot(F, P),
                                          m03: 0, m13: 0, m23: 0, m33: 1)
        
        let aspectRatio = Float(view.frame.size.width / view.frame.size.height)
        let fov = 90 * (Float.pi / 180.0)
        let nearZ: Float = 0.1
        let farZ: Float = 100.0
        
        let perspectiveMatrix = matrix_perspective_right_hand(fovyRadians: fov, aspect: aspectRatio, nearZ: nearZ, farZ: farZ)
        
        self.transformation = TransformationData(modelMatrix: modelMatrix, viewMatrix: viewMatrix, perspectiveMatrix: perspectiveMatrix)
    }
}
