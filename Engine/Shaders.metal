//
//  Shaders.metal
//  Engine
//
//  Created by matty on 2/7/25.
//

#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;

struct Vertex {
    float4 position;
    float2 texCoords;
};

struct TransformationData {
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 perspectiveMatrix;
};

struct RasterizerData {
    float4 position [[position]];
    float2 texCoords;
};

vertex RasterizerData
vertexShader(uint vertexID [[vertex_id]],
             constant Vertex *vertices [[buffer(0)]],
             constant TransformationData* transformationData) {
    RasterizerData out;
        
    out.position = transformationData->perspectiveMatrix * transformationData->viewMatrix * transformationData->modelMatrix * vertices[vertexID].position;
    out.texCoords = vertices[vertexID].texCoords;
    
    return out;
}

fragment float4 fragmentShader(RasterizerData in [[stage_in]],
                               texture2d<float> colorTexture [[texture(0)]]) {
    constexpr sampler textureSampler (mag_filter::linear, min_filter::linear);
    const float4 colorSample = colorTexture.sample(textureSampler, in.texCoords);
    return colorSample;
}


