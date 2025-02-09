//
//  Block.swift
//  Engine
//
//  Created by matty on 2/8/25.
//

enum BlockType {
    case grass
}

struct Block {
    let blockType: BlockType
    var isActive: Bool
}
