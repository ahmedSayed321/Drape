//
//  DrapeApp.swift
//  Drape
//
//  Created by Moaz on 27/06/2026.
//

import SwiftUI
import FirebaseCore
import SwiftData

@main
struct DrapeApp: App {
    
    let container: ModelContainer = {
        let schema = Schema([
            SavedProductModel.self
            // future: OtherFeatureModel.self, etc.
        ])
        return try! ModelContainer(for: schema)
    }()

    @State private var router = AppRouter()
    var draftOrderId: String = ""
    
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
                CheckoutView(cartItems: router.cartItems, draftOrderId: router.draftOrderId)
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
            case .addCard:
                AddCardView()
                    .environment(router)
            case .cart:
                CartView(viewModel: .live(draftOrderId: router.draftOrderId.isEmpty ? nil : router.draftOrderId))
                    .environment(router)
            }

        }
        .modelContainer(container)
    }
}
