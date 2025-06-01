//
//  AdvancedAnim.swift
//  DemoApp
//
//  Created by Cristhian Leon on 1/6/25.
//

import SwiftUI
import AnimationSequence

struct AdvancedAnim: View {
    struct AnimationState {
        var bigDiamondX: CGFloat = UIScreen.main.bounds.width / 2
        var bigDiamondY: CGFloat = -10
        var bigDiamondSize: CGFloat = 250
        
        var smallDiamondX: CGFloat = UIScreen.main.bounds.width / 2
        var smallDiamondY: CGFloat = UIScreen.main.bounds.height + 100
        var smallDiamondSize: CGFloat = 250
        
        var formOpacity: CGFloat = 0
        var isLoading = false
    }
    
    private let grayColor = Color.init(uiColor: UIColor(red: 212/255, green: 212/255, blue: 212/255, alpha: 1))
    @State private var animState = AnimationState()
    
    var body: some View {
        ZStack {
            signInForm
                .opacity(animState.formOpacity)
            
            if animState.isLoading {
                ProgressView()
            }
            
            DiamondView(
                color: Color.yellow.opacity(0.5),
                size: animState.bigDiamondSize
            )
            .position(
                CGPoint(
                    x: animState.bigDiamondX,
                    y: animState.bigDiamondY
                )
            )
            
            DiamondView(
                color: Color.yellow.opacity(0.7),
                size: animState.smallDiamondSize
            )
            .position(
                CGPoint(
                    x: animState.smallDiamondX,
                    y: animState.smallDiamondY
                )
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .ignoresSafeArea()
        .background(Color.white)
        .onAppear {
            animateViews()
        }
    }
    
    private func animateViews() {
        AnimationSequence(delay: 0.5)
            .async(duration: 0.4, easing: .easeInOut) {
                animState.bigDiamondY = -100
                animState.bigDiamondSize = 600
            }
            .async(duration: 0.5, easing: .easeInOut) {
                animState.smallDiamondY = 0
                animState.smallDiamondSize = 380
            }
            .add {
                withAnimation(.easeInOut(duration: 1)) {
                    animState.formOpacity = 1
                }
            }
            .start()
    }
    
    @ViewBuilder
    private var signInForm: some View {
        VStack(spacing: 10) {
            VStack {
                TextField("Email", text: .constant("email@gmail.com"))
                    .padding()
                    .foregroundColor(.black)
            }
            .background(grayColor)
            .cornerRadius(10)
            
            VStack {
                SecureField("Password", text: .constant("password"))
                    .padding()
                    .foregroundColor(.black)
            }
            .background(grayColor)
            .cornerRadius(10)
            .padding(.bottom, 10)
            
            Button {
                AnimationSequence()
                    .async(duration: 0.3, easing: .easeInOut) {
                        animState.smallDiamondY = -UIScreen.main.bounds.height
                    }
                    .async(delay: 0.1, duration: 0.3, easing: .easeInOut) {
                        animState.bigDiamondY = -UIScreen.main.bounds.height
                    }
                    .add {
                        animState.formOpacity = 0
                        animState.isLoading = true
                    }
                    .start()
            } label: {
                Text("Sign in")
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black)
            .cornerRadius(10)
        }
        .padding(20)
        .padding(.top, 100)
    }
}

struct DiamondView: View {
    var color: Color = .black
    var size: CGFloat = 200
    var cornerRadius: CGFloat = 20
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(color)
            .frame(width: size, height: size)
            .rotationEffect(.degrees(45))
    }
}

#Preview {
    AdvancedAnim()
}
