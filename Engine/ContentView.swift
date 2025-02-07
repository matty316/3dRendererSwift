//
//  ContentView.swift
//  Engine
//
//  Created by matty on 2/7/25.
//

import SwiftUI

struct ContentView: View {
    init() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { _ in
            nil
        }
    }
    var body: some View {
        MetalView()
    }
}

#Preview {
    ContentView()
}
