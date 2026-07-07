//
//  FAQItem.swift
//  Drape
//
//  Created by Moaz on 06/07/2026.
//

import Foundation

enum FAQCategory: String, CaseIterable, Identifiable {
    case general = "General"
    case account = "Account"
    case service = "Service"
    case payment = "Payment"

    var id: String { rawValue }
}

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
    let category: FAQCategory
}

extension FAQItem {
    static let all: [FAQItem] = [
        // General
        FAQItem(
            question: "How do I make a purchase?",
            answer: "When you find a product you want to purchase, tap on it to view the product details. Check the price, description, and available options (if applicable), and then tap the \"Add to Cart\" button. Follow the on-screen instructions to complete the purchase, including providing shipping details and payment information.",
            category: .general
        ),
        FAQItem(
            question: "How do I track my orders?",
            answer: "Go to My Orders in your account and tap on any order to see its current status and tracking details.",
            category: .general
        ),
        FAQItem(
            question: "Can I cancel or return an order?",
            answer: "Yes, orders can be cancelled before they're shipped. Once delivered, returns are accepted within our return policy window.",
            category: .general
        ),

        // Account
        FAQItem(
            question: "How do I update my account details?",
            answer: "Go to Account > My Details, edit your name, email, or phone number, then tap Save.",
            category: .account
        ),
        FAQItem(
            question: "How do I reset my password?",
            answer: "Tap \"Forgot Password\" on the login screen and follow the instructions sent to your email.",
            category: .account
        ),
        FAQItem(
            question: "How do I delete my account?",
            answer: "Contact Customer Service through the Help Center to request account deletion.",
            category: .account
        ),

        // Service
        FAQItem(
            question: "How can I contact customer support?",
            answer: "You can reach us through the Help Center — via Customer Service, WhatsApp, or any of our social media channels.",
            category: .service
        ),
        FAQItem(
            question: "What are your support hours?",
            answer: "Our support team is available daily from 9 AM to 10 PM.",
            category: .service
        ),

        // Payment
        FAQItem(
            question: "What payment methods are accepted?",
            answer: "We accept major credit/debit cards, cash on delivery, and other payment options available at checkout.",
            category: .payment
        ),
        FAQItem(
            question: "Is it safe to save my card details?",
            answer: "Yes, all payment information is securely encrypted and processed through trusted payment providers.",
            category: .payment
        )
    ]
}
