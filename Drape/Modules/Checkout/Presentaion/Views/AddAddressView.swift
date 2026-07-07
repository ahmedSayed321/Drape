//
//  AddAddressView.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//
import SwiftUI
import MapKit
import UIKit

struct AddAddressView: View {

    @Environment(AppRouter.self) private var router
    @State private var viewModel = AddAddressViewModel()
    @State private var isSheetPresented = true

    // initial on Cairo
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 30.0444, longitude: 31.2357),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    var body: some View {

        ZStack {

            VStack(spacing: 0) {

                StandardAppBar(
                    title: "New Address",
                    trailingSystemImage: "bell",
                    onBackTapped: {
                        router.showAddress()
                    },
                    onTrailingTapped: { }
                )

                mapSection
            }
            .ignoresSafeArea(edges: .bottom)
            .sheet(isPresented: $isSheetPresented) {
                addressFormSheet
            }

            if viewModel.state.isSuccessVisible {
                successOverlay
            }
        }
        .animation(.easeInOut, value: viewModel.state.isSuccessVisible)
        .onChange(of: viewModel.state.isSuccessVisible) { _, isVisible in
            if isVisible {
                isSheetPresented = false
            }
        }
    }
}

private extension AddAddressView {
    var mapSection: some View {
        ZStack(alignment: .topTrailing) {
            MapUIView(
                region: $region,
                selectedCoordinate: Binding(
                    get: { viewModel.state.selectedCoordinate },
                    set: { newValue in
                        if let coord = newValue {
                            viewModel.updatePickedLocation(coord)
                        }
                    }
                )
            )
            .frame(maxHeight: .infinity)
            zoomControls
                .padding(.top, 16)
                .padding(.trailing, 16)
        }
    }

    var zoomControls: some View {
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

    func zoomIn() {
        region.span.latitudeDelta = max(region.span.latitudeDelta / 2, 0.002)
        region.span.longitudeDelta = max(region.span.longitudeDelta / 2, 0.002)
    }

    func zoomOut() {
        region.span.latitudeDelta = min(region.span.latitudeDelta * 2, 60)
        region.span.longitudeDelta = min(region.span.longitudeDelta * 2, 60)
    }
}

private extension AddAddressView {
    var addressFormSheet: some View {

        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Address")
                    .font(.system(size: 28, weight: .bold))
                Spacer()
                Button {
                    isSheetPresented = false
                    router.showAddress()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.black)
                }
            }
            .padding(.top, 8)

            Divider()
                .padding(.top, 12)

            VStack(alignment: .leading, spacing: 16) {

                CustomTextField(
                    title: "Address Nickname",
                    errorMessage: "Please enter address nickname",
                    placeHolder: "Home, Office...",
                    textFieldValue: Binding(
                        get: { viewModel.state.nickname },
                        set: { viewModel.updateNickname($0) }
                    ),
                    state: Binding(
                        get: { viewModel.state.nicknameState },
                        set: { viewModel.state.nicknameState = $0 }
                    )
                )

                CustomTextField(
                    title: "Full Address",
                    errorMessage: "Please enter full address",
                    placeHolder: "Enter full address",
                    textFieldValue: Binding(
                        get: { viewModel.state.fullAddress },
                        set: { viewModel.updateFullAddress($0) }
                    ),
                    state: Binding(
                        get: { viewModel.state.fullAddressState },
                        set: { viewModel.state.fullAddressState = $0 }
                    )
                )

                if viewModel.state.selectedCoordinate == nil {
                    Text("Tap on the map to pick location")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                } else {
                    Text("Location selected")
                        .font(.footnote)
                        .foregroundStyle(.green)
                }

                CustomButton(
                    type: .primary,
                    text: viewModel.state.isSaving ? "Adding..." : "Add",
                    action: {
                        viewModel.addAddress()
                    },
                    status: viewModel.state.isAddEnabled ? .enable : .disable
                )
            }
            .padding(.top, 20)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .presentationDetents([.height(350)])
        .presentationDragIndicator(.hidden)
        .presentationBackgroundInteraction(.enabled)
        .interactiveDismissDisabled(true)
    }
}

private extension AddAddressView {
    var successOverlay: some View {

        ZStack {

            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: 18) {

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(.green)

                Text("Congratulations!")
                    .font(.title.bold())

                Text("Your new address has been added.")
                    .foregroundStyle(.secondary)

                CustomButton(
                    type: .primary,
                    text: "Thanks",
                    action: {
                        viewModel.dismissSuccess()
                        isSheetPresented = false
                        router.showAddress()
                    },
                    status: .enable
                )
            }
            .padding(28)
            .frame(width: 320)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(radius: 20)
        }
        .zIndex(100)
    }
}

private struct MapUIView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var selectedCoordinate: CLLocationCoordinate2D?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)
        mapView.showsUserLocation = true
        mapView.mapType = .standard

        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        mapView.addGestureRecognizer(tap)

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)

        if let coord = selectedCoordinate {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coord
            uiView.addAnnotation(annotation)
        }

        if !context.coordinator.isUpdatingFromMap {
            let current = uiView.region
            let latDiff = abs(current.span.latitudeDelta - region.span.latitudeDelta)
            let lonDiff = abs(current.span.longitudeDelta - region.span.longitudeDelta)
            let centerDiff = abs(current.center.latitude - region.center.latitude)
                + abs(current.center.longitude - region.center.longitude)

            if latDiff > 0.0001 || lonDiff > 0.0001 || centerDiff > 0.0001 {
                uiView.setRegion(region, animated: true)
            }
        }
    }

    final class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapUIView
        var isUpdatingFromMap = false

        init(_ parent: MapUIView) {
            self.parent = parent
            super.init()
        }

        @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            guard let mapView = gestureRecognizer.view as? MKMapView else { return }
            let point = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)

            DispatchQueue.main.async {
                self.parent.selectedCoordinate = coordinate
            }
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation { return nil }
            let id = "picked"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: id)
            if view == nil {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: id)
                view?.canShowCallout = false
            } else {
                view?.annotation = annotation
            }
            return view
        }

        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            isUpdatingFromMap = true
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            isUpdatingFromMap = false
            DispatchQueue.main.async {
                self.parent.region = mapView.region
            }
        }
    }
}
