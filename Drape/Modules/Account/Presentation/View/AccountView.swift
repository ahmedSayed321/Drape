//
//  AccountView.swift
//  Drape
//
//  Created by Moaz on 05/07/2026.
//
import SwiftUI
import SwiftData

struct AccountView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: AccountViewModel
    @State private var showLogoutAlert = false
    @State private var showGuestAlert = false
    @State private var path = NavigationPath()
    @Environment(AppRouter.self) private var router

    init() {
        // Defer the actual use-case wiring to onAppear since @Environment
        // isn't available at init time. Start with a bare ViewModel.
        _viewModel = StateObject(wrappedValue: AccountViewModel())
    }
    
    private let keychain = KeychainTokenStorage()

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 0) {
                            sectionGroup {
                                AccountItemView(icon: "shippingbox", title: "My Orders") {
                                    runGuestProtectedAction {
                                        path.append(AccountDestination.myOrders)
                                    }
                                }
                            }
                            sectionDivider()
                            sectionGroup {
                                AccountItemView(icon: "person.text.rectangle", title: "My Details") {
                                    runGuestProtectedAction {
                                        path.append(AccountDestination.myDetails)
                                    }
                                }
                                rowDivider()
                                AccountItemView(icon: "house", title: "Address Book") {
                                    runGuestProtectedAction {
                                        path.append(AccountDestination.addressBook)
                                    }
                                }
                                rowDivider()
                                AccountItemView(icon: "creditcard", title: "Payment Methods") {
                                    runGuestProtectedAction {
//                                        path.append(AccountDestination.paymentMethods)
                                    }
                                }
                                rowDivider()
                                AccountItemView(icon: "bell", title: "Notifications") {
                                    runGuestProtectedAction {
                                        openAppSettings()
                                    }
                                }
                            }
                            sectionDivider()
                            sectionGroup {
                                AccountItemView(icon: "questionmark.circle", title: "FAQs") {
                                    runGuestProtectedAction {
                                        path.append(AccountDestination.faqs)
                                    }
                                }
                                rowDivider()
                                AccountItemView(icon: "headphones", title: "Help Center") {
                                    runGuestProtectedAction {
                                        path.append(AccountDestination.helpCenter)
                                    }
                                }
                            }
                            sectionDivider()
                            sectionGroup {
                                AccountItemView(
                                    icon: "",
                                    title: viewModel.isLoggingOut ? "Logging out..." : "Logout",
                                    isLogOut: true
                                ) {
                                    runGuestProtectedAction {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            showLogoutAlert = true
                                        }
                                    }
                                }
                                .disabled(viewModel.isLoggingOut)

                                if let logoutError = viewModel.logoutError {
                                    Text(logoutError)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundStyle(.red)
                                        .padding(.top, 4)
                                }
                            }
                        }
                    }
                    .clipped()
                }
                .background(Color.white)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Account")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.black)
                    }
                }
                .navigationDestination(for: AccountDestination.self) { destination in
                    destinationView(for: destination,email : viewModel.getEmailForUser())
                }

                if showLogoutAlert {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showLogoutAlert = false
                            }
                        }

                    LogoutConfirmationView(
                        onConfirm: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showLogoutAlert = false
                            }
                            if viewModel.logout() {
                                router.showSignIn()
                            }
                        },
                        onCancel: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showLogoutAlert = false
                            }
                        }
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: showLogoutAlert)
            .alert("Login Required", isPresented: $showGuestAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Go to Login") {
                    router.showSignIn()
                }
            } message: {
                Text("You need to login first to use account features.")
            }
            .onAppear {
                if viewModel.clearFavoritesUseCase == nil {
                    let dataSource = SavedProductsLocalDataSourceImpl(context: modelContext)
                    let repository = SavedProductsRepositoryImpl(localDataSource: dataSource)
                    viewModel.clearFavoritesUseCase = ClearAllSavedProductsUseCase(repository: repository)
                }
            }
        }
    }

    // Destination routing

    @ViewBuilder
    private func destinationView(for destination: AccountDestination, email : String) -> some View {
        switch destination {
        case .myDetails:
            MyDetailsView()
        case .faqs:
            FaqsView()
        case .helpCenter:
            HelpCenterView()
        case .myOrders:
            OrdersModuleFactory.makeOrdersView(customerEmail:email)
        case .addressBook:
            AddressDetailView()
        }
    }

    // Helpers

    @ViewBuilder
    private func sectionGroup<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0) {
            content()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private func rowDivider() -> some View {
        Divider()
            .padding(.horizontal, 40)
    }

    @ViewBuilder
    private func sectionDivider() -> some View {
        Rectangle()
            .fill(Color(hex: "E6E6E6"))
            .frame(height: 8)
    }
    
    private var isGuest: Bool {
        guard let customerId = keychain.getShopifyCustomerID() else {
            return true
        }
        return customerId.isEmpty
    }
    
    private func runGuestProtectedAction(_ action: () -> Void) {
        guard !isGuest else {
            showGuestAlert = true
            return
        }
        action()
    }
}

#Preview {
    AccountView()
        .environment(AppRouter())
}
