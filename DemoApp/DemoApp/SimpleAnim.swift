//
//  SimpleAnim.swift
//  DemoApp
//
//  Created by Cristhian Leon on 1/6/25.
//

import SwiftUI
import AnimationSequence

struct SimpleAnim: View {
    struct AnimationState {
        var color: Color = .green
    }
    
    @State private var animationState = AnimationState()
    
    var body: some View {
        VStack(spacing: 30) {
            Rectangle()
                .fill(animationState.color)
                .cornerRadius(20)
                .frame(width: 200, height: 200)
            
            Button("Start sequence") {
                animateViews()
            }
            .foregroundColor(Color.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
        }
        .navigationTitle("Simple Animation")
    }
    
    private func animateViews() {
        AnimationSequence()
            .add(duration: 1, easing: .easeInOut) {
                animationState.color = Color.red
            }
            .add(delay: 2, duration: 0.5) {
                animationState.color = Color.blue
            }
            .debug()
            .start()
    }
}

#Preview {
    SimpleAnim()
}
