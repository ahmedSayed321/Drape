//
//  SplashScreen.swift
//  Drape
//
//  Created by Me3bed on 27/06/2026.
//

import SwiftUI

struct SplashScreen: View {

    @Environment(AppRouter.self) private var router

    @AppStorage("isFirstLaunch")
    private var isFirstLaunch = true
    
    private let tokenStorage = KeychainTokenStorage()

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            Image("drape_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)

        }
        .task {

            try? await Task.sleep(for: .seconds(3))

            navigateAfterSplash()

        }
    }
    
    private func navigateAfterSplash() {

        if isFirstLaunch {
            router.showOnBoarding()
            return
        }

        let customerID = tokenStorage.getShopifyCustomerID()

        if let customerID, !customerID.isEmpty {
            //router.showHome()
        } else {
            router.showSignIn()
        }
    }
}
