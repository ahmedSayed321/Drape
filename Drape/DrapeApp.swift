//
//  DrapeApp.swift
//  Drape
//
//  Created by Moaz on 27/06/2026.
//

import SwiftUI
import FirebaseCore

@main
struct DrapeApp: App {

    @State private var router = AppRouter()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {

            switch router.currentScreen {

            case .splash:
                SplashScreen()
                    .environment(router)

            case .signIn:
                SignInView()
                    .environment(router)

            case .signUp:
                SignupView()
                    .environment(router)

            case .onBoarding:
                OnBoardingScreen()
                    .environment(router)
            case .home:
                ContentView()
                    .environment(router)
            case .checkout:
                CheckoutView()
                    .environment(router)
            case .address:
                AddressView()
                    .environment(router)
            case .addAddress:
                AddAddressView()
                    .environment(router)
            case .payment:
                PaymentMethodView()
                    .environment(router)
            }

        }
    }
}
