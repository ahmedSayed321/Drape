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
            }

        }
        .modelContainer(container)
    }
}
