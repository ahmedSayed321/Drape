//
//  OnBoardingScreen.swift
//  Drape
//
//  Created by Me3bed on 27/06/2026.
//

import SwiftUI

struct OnBoardingScreen: View {
    
    @Environment(AppRouter.self) private var router

    @AppStorage("isFirstLaunch")
    private var isFirstLaunch = true
    var body: some View {
        VStack(spacing: 0) {
            
            ZStack(alignment: .topLeading) {
                
                Image("onboarding")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.75)
                    .clipped()
                    .offset(x: 40)
                
                Text("Define\nyourself in\nyour unique\nway.")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 24)
                
            }
            .padding(.bottom,10)
            
            CustomButton(type: .primary, text: "Get Started", action: {
                withAnimation {
                    isFirstLaunch = false
                    router.showSignIn()
                    //router.currentScreen = .signIn
                }
            },trailing: Image(systemName: "arrow.right"))
            .padding(.all,15)
            
        }
        .ignoresSafeArea(edges: .top)
        .background(Color.white)
    }
}

#Preview {
    OnBoardingScreen()
}
