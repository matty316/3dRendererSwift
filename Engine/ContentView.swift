//
//  ContentView.swift
//  Engine
//
//  Created by matty on 2/7/25.
//

import SwiftUI

struct ContentView: View {
    @State var angle = 0.0
    var body: some View {
        MetalView(angle: $angle)
        Text("\(angle)")
        Slider(value: $angle, in: 0.0...180.0) {
            Text("angle")
        }
    }
}

#Preview {
    ContentView()
}
