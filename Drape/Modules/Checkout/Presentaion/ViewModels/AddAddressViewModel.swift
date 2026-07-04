//
//  AddAddressViewModel.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//
import Foundation
import CoreLocation
import SwiftUI
import MapKit

@MainActor
@Observable
final class AddAddressViewModel {
    var state = AddAddressUiState()

    func updateNickname(_ value: String) {
        state.nickname = value
        state.nicknameState = value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .error : .normal
    }

    func updateFullAddress(_ value: String) {
        state.fullAddress = value
        state.fullAddressState = value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .error : .normal
    }

    func updatePickedLocation(_ coordinate: CLLocationCoordinate2D) {
        state.selectedCoordinate = coordinate
    }

    func addAddress() async {
        let trimmedNickname = state.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAddress = state.fullAddress.trimmingCharacters(in: .whitespacesAndNewlines)

        state.nicknameState = trimmedNickname.isEmpty ? .error : .normal
        state.fullAddressState = trimmedAddress.isEmpty ? .error : .normal

        guard !trimmedNickname.isEmpty,
              !trimmedAddress.isEmpty,
              state.selectedCoordinate != nil else {
            return
        }

        state.isSaving = true
        try? await Task.sleep(nanoseconds: 700_000_000)
        state.isSaving = false
        state.isSuccessVisible = true
    }

    func dismissSuccess() {
        state.isSuccessVisible = false
    }

    func makeAddressItem() -> AddressItem {
        AddressItem(
            id: UUID(),
            title: state.nickname,
            details: state.fullAddress,
            isDefault: false,
            latitude: state.selectedCoordinate?.latitude,
            longitude: state.selectedCoordinate?.longitude
        )
    }
}
