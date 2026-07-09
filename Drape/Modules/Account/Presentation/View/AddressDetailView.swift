//
//  AddressDetailView.swift
//  Drape
//
//  Created by TaqieAllah on 09/07/2026.
//

import Foundation
import SwiftUI
import MapKit

struct AddressDetailView: View {
    @State private var addresses: [AddressItem] = []

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 30.0444, longitude: 31.2357),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 30.0444, longitude: 31.2357),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )

    private var pinned: [AddressItem] {
        addresses.filter { $0.latitude != nil && $0.longitude != nil }
    }

    var body: some View {
        VStack(spacing: 0) {
            if addresses.isEmpty {
                emptyState
            } else {
                if !pinned.isEmpty {
                    mapSection
                        .frame(height: 350)
                }

                List(addresses) { address in
                    row(for: address)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Address Book")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadAddresses)
    }

    private var mapSection: some View {
        ZStack(alignment: .topTrailing) {
            Map(position: $cameraPosition, interactionModes: [.pan, .zoom]) {
                ForEach(pinned) { address in
                    Marker(
                        address.title,
                        coordinate: CLLocationCoordinate2D(
                            latitude: address.latitude!,
                            longitude: address.longitude!
                        )
                    )
                }
            }
            zoomControls
                .padding(.top, 16)
                .padding(.trailing, 16)
        }
    }

    private var zoomControls: some View {
        VStack(spacing: 0) {
            Button(action: zoomIn) {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 44, height: 44)
            }
            Divider()
                .frame(width: 30)
            Button(action: zoomOut) {
                Image(systemName: "minus")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 44, height: 44)
            }
        }
        .foregroundStyle(.black)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 4)
    }

    private func zoomIn() {
        region.span.latitudeDelta = max(region.span.latitudeDelta / 2, 0.002)
        region.span.longitudeDelta = max(region.span.longitudeDelta / 2, 0.002)
        cameraPosition = .region(region)
    }

    private func zoomOut() {
        region.span.latitudeDelta = min(region.span.latitudeDelta * 2, 60)
        region.span.longitudeDelta = min(region.span.longitudeDelta * 2, 60)
        cameraPosition = .region(region)
    }

    private func loadAddresses() {
        addresses = CheckoutStorage.shared.loadAddresses()
        if let first = pinned.first {
            region.center = CLLocationCoordinate2D(latitude: first.latitude!, longitude: first.longitude!)
            cameraPosition = .region(region)
        }
    }

    private func row(for address: AddressItem) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(address.title)
                    .font(.system(size: 16, weight: .semibold))
                if address.isDefault {
                    Text("Default")
                        .font(.caption2)
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(Color(hex: "E6E6E6"))
                        .clipShape(Capsule())
                }
            }
            Text(address.details)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "house")
                .font(.system(size: 40))
                .foregroundStyle(.gray)
            Text("No saved addresses yet")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
