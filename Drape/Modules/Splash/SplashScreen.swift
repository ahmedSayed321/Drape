//
//  SplashScreen.swift
//  Drape
//
//  Created by Me3bed on 27/06/2026.
//

import SwiftUI

struct SplashScreen: View {
    @State private var showOnboarding = false
    
    var body: some View {
        if showOnboarding {
            OnBoardingScreen()
        } else {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                Image("drape_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeInOut) {
                        showOnboarding = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
