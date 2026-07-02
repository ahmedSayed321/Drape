//
//  OnBoardingScreen.swift
//  Drape
//
//  Created by Me3bed on 27/06/2026.
//

import SwiftUI

struct OnBoardingScreen: View {
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
            
            Button(action: {
                
            }) {
                HStack {
                    Text("Get Started")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.black)
                .cornerRadius(12)
                .padding(.horizontal, 24)
            }
            .padding(.top, 24)
        }
        .ignoresSafeArea(edges: .top)
        .background(Color.white)
    }
}

#Preview {
    OnBoardingScreen()
}
