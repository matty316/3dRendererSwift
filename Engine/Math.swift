//
//  Math.swift
//  Engine
//
//  Created by matty on 2/7/25.
//

import simd

func matrix_make_rows(m00: Float, m10: Float, m20: Float, m30: Float,
                      m01: Float, m11: Float, m21: Float, m31: Float,
                      m02: Float, m12: Float, m22: Float, m32: Float,
                      m03: Float, m13: Float, m23: Float, m33: Float) -> matrix_float4x4 {
    matrix_float4x4(
        [m00, m01, m02, m03],
        [m10, m11, m12, m13],
        [m20, m21, m22, m23],
        [m30, m31, m32, m33])
}

func matrix4x4_translation(tx: Float, ty: Float, tz: Float) -> matrix_float4x4 {
    matrix_make_rows(m00: 1, m10: 0, m20: 0, m30: tx,
                     m01: 0, m11: 1, m21: 0, m31: ty,
                     m02: 0, m12: 0, m22: 1, m32: tz,
                     m03: 0, m13: 0, m23: 0,  m33: 1 )
}

func matrix4x4_rotation(radians: Float, axis: SIMD3<Float>) -> matrix_float4x4 {
    let normal = simd_normalize(axis)
    let ct = cos(radians)
    let st = sin(radians)
    let ci = 1 - ct
    let x = normal.x
    let y = normal.y
    let z = normal.z
    return matrix_make_rows(m00: ct + x * x * ci, m10:  x * y * ci - z * st, m20: x * z * ci + y * st, m30: 0,
                            m01: y * x * ci + z * st, m11: ct + y * y * ci, m21: y * z * ci - x * st, m31: 0,
                            m02: z * x * ci - y * st, m12: z * y * ci + x * st, m22: ct + z * z * ci, m32: 0,
                            m03: 0, m13: 0, m23: 0, m33: 1)
}

func matrix_perspective_right_hand(fovyRadians: Float, aspect: Float, nearZ: Float, farZ: Float) -> matrix_float4x4 {
    let ys = 1 / tan(fovyRadians * 0.5)
    let xs = ys / aspect
    let zs = farZ / (nearZ - farZ)
    return matrix_make_rows(m00: xs, m10: 0, m20: 0, m30: 0,
                            m01: 0, m11: ys, m21: 0, m31: 0,
                            m02: 0, m12: 0, m22: zs, m32: nearZ * zs,
                            m03: 0, m13: 0, m23: -1, m33: 0)
}
