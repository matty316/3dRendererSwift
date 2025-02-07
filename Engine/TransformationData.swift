//
//  TransformationData.swift
//  Engine
//
//  Created by matty on 2/7/25.
//

import simd

struct TransformationData {
    var modelMatrix: matrix_float4x4
    var viewMatrix: matrix_float4x4
    var perspectiveMatrix: matrix_float4x4
}
