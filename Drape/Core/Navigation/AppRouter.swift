//
//  AppRouter.swift
//  Drape
//
//  Created by Me3bed on 01/07/2026.
//

import Foundation
import Observation

@Observable
final class AppRouter {

    var currentScreen: AppScreen = .splash

    func showSplash() {
        currentScreen = .splash
    }

    func showOnBoarding() {
        currentScreen = .onBoarding
    }

    func showSignIn() {
        currentScreen = .signIn
    }

    func showSignUp() {
        currentScreen = .signUp
    }

//    func showHome() {
//        currentScreen = .home
//    }
}
