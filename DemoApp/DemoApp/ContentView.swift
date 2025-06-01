//
//  ContentView.swift
//  DemoApp
//
//  Created by Cristhian Leon on 1/6/25.
//

import SwiftUI
//import AnimationSequence

struct ContentView: View {
//    var r = AnimationSequence(duration: 0.5, delay: 0, easing: .default)
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
