//
//  ContentView.swift
//  DemoApp
//
//  Created by Cristhian Leon on 1/6/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Simple animation", destination: SimpleAnim())
                NavigationLink("Advanced animation", destination: AdvancedAnim())
            }
            .navigationTitle("Demo App")
        }
    }
}

#Preview {
    ContentView()
}
