//
//  AccountView.swift
//  Drape
//
//  Created by Moaz on 05/07/2026.
//
import SwiftUI

struct AccountView: View {
    @StateObject private var viewModel = AccountViewModel()
    @State private var showLogoutAlert = false
    @State private var path = NavigationPath()
    @Environment(AppRouter.self) private var router

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 0) {
                            sectionGroup {
                                AccountItemView(icon: "shippingbox", title: "My Orders") {
                                    path.append(AccountDestination.myOrders)
                                }
                            }
                            sectionDivider()
                            sectionGroup {
                                AccountItemView(icon: "person.text.rectangle", title: "My Details") {
                                    path.append(AccountDestination.myDetails)
                                }
                                rowDivider()
                                AccountItemView(icon: "house", title: "Address Book") {
//                                    path.append(AccountDestination.addressBook)
                                }
                                rowDivider()
                                AccountItemView(icon: "creditcard", title: "Payment Methods") {
//                                    path.append(AccountDestination.paymentMethods)
                                }
                                rowDivider()
                                AccountItemView(icon: "bell", title: "Notifications") {
                                    openAppSettings()
                                }
                            }
                            sectionDivider()
                            sectionGroup {
                                AccountItemView(icon: "questionmark.circle", title: "FAQs") {
                                    path.append(AccountDestination.faqs)
                                }
                                rowDivider()
                                AccountItemView(icon: "headphones", title: "Help Center") {
                                    path.append(AccountDestination.helpCenter)
                                }
                            }
                            sectionDivider()
                            sectionGroup {
                                AccountItemView(
                                    icon: "",
                                    title: viewModel.isLoggingOut ? "Logging out..." : "Logout",
                                    isLogOut: true
                                ) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        showLogoutAlert = true
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
}

#Preview {
    AccountView()
        .environment(AppRouter())
}
