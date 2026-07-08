import Foundation
import CoreLocation

/// Value-type view model used with @State in AddAddressView.
struct AddAddressViewModel {
    var state = AddAddressUiState()

    mutating func updateNickname(_ value: String) {
        state.nickname = value
        state.nicknameState = value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .error : .success
    }

    mutating func updateFullAddress(_ value: String) {
        state.fullAddress = value
        state.fullAddressState = value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .error : .success
    }

    mutating func toggleDefaultAddress() {
        state.isDefaultAddress.toggle()
    }

    mutating func updatePickedLocation(_ coord: CLLocationCoordinate2D) {
        state.selectedCoordinate = coord
    }

    mutating func addAddress() async {
        guard state.isAddEnabled else { return }
        state.isSaving = true

        // simulate work
        try? await Task.sleep(nanoseconds: 400_000_000)

        let addr = AddressItem(
            id: UUID(),
            title: state.nickname,
            details: state.fullAddress,
            isDefault: state.isDefaultAddress,
            latitude: state.selectedCoordinate?.latitude,
            longitude: state.selectedCoordinate?.longitude
        )

        CheckoutStorage.shared.addAddress(addr)

        state.isSaving = false
        state.isSuccessVisible = true
    }

    func makeAddressItem() -> AddressItem {
        AddressItem(
            id: UUID(),
            title: state.nickname,
            details: state.fullAddress,
            isDefault: state.isDefaultAddress,
            latitude: state.selectedCoordinate?.latitude,
            longitude: state.selectedCoordinate?.longitude
        )
    }

    mutating func dismissSuccess() {
        state.isSuccessVisible = false
        // clear form
        state.nickname = ""
        state.fullAddress = ""
        state.selectedCoordinate = nil
        state.isDefaultAddress = false
    }
}
