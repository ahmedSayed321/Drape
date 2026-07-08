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
    var cartItems: [CartItem] = []
    var draftOrderId: String = ""
    var selectedAddress: AddressItem?
    var selectedCard: CardItem?

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

    func showHome() {
        currentScreen = .home
    }
    
    func showCheckout() {
        currentScreen = .checkout
    }
    
    func showAddress() {
        currentScreen = .address
    }
    
    func showAddAddress() {
        currentScreen = .addAddress
    }
    
    func showPayment() {
        currentScreen = .payment
    }
    func showAddCard() {
        currentScreen = .addCard
    }
    func showCart() {
        currentScreen = .cart
    }
}
