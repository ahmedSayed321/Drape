//
//  PaymentRequest.swift
//  Drape
//

import Foundation

struct PaymentRequest: Equatable {
    let amountCents: Int
    let currency: String
    let merchantOrderId: String?
    let billingData: PaymentBillingData
    let items: [PaymentItem]

    init(
        amountCents: Int,
        currency: String = "EGP",
        merchantOrderId: String? = nil,
        billingData: PaymentBillingData,
        items: [PaymentItem] = []
    ) {
        self.amountCents = amountCents
        self.currency = currency
        self.merchantOrderId = merchantOrderId
        self.billingData = billingData
        self.items = items
    }
}

struct PaymentBillingData: Equatable {
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String
    let apartment: String
    let floor: String
    let street: String
    let building: String
    let city: String
    let country: String
    let state: String

    init(
        firstName: String,
        lastName: String,
        email: String,
        phoneNumber: String,
        apartment: String = "NA",
        floor: String = "NA",
        street: String = "NA",
        building: String = "NA",
        city: String = "Cairo",
        country: String = "EG",
        state: String = "Cairo"
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.apartment = apartment
        self.floor = floor
        self.street = street
        self.building = building
        self.city = city
        self.country = country
        self.state = state
    }
}

struct PaymentItem: Equatable {
    let name: String
    let amountCents: Int
    let description: String
    let quantity: Int
}
