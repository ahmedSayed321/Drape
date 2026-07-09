//
//  PaymentView.swift
//  Drape
//

import SwiftUI

struct PaymentView: View {
    @State private var viewModel: PaymentViewModel
    let onCompletion: (PaymentResult) -> Void

    init(
        paymentRequest: PaymentRequest,
        method: PaymentMethod = .paymob,
        onCompletion: @escaping (PaymentResult) -> Void
    ) {
        _viewModel = State(initialValue: PaymentViewModel(paymentRequest: paymentRequest, method: method))
        self.onCompletion = onCompletion
    }

    var body: some View {
        VStack(spacing: 0) {
            StandardAppBar(
                title: "Payment",
                trailingSystemImage: "xmark",
                onBackTapped: {
                    viewModel.cancelPayment()
                },
                onTrailingTapped: {
                    viewModel.cancelPayment()
                }
            )

            content
        }
        .background(Color.white)
        .task {
            await viewModel.startPayment()
        }
        .onChange(of: viewModel.state) { _, newState in
            switch newState {
            case .success(let result):
                onCompletion(result)
            case .cancelled:
                onCompletion(.cancelled)
            default:
                break
            }
        }
    }
}

private extension PaymentView {
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.2)
                Text("Preparing secure payment...")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .paymentReady(let session):
            PaymentWebView(url: session.paymentURL) { url in
                viewModel.handleRedirect(url: url)
            }

        case .failure(let message):
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(.red)

                Text("Payment Failed")
                    .font(.title3.bold())

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)

                CustomButton(
                    type: .primary,
                    text: "Back to Checkout",
                    action: {
                        onCompletion(.failure(message: message))
                    },
                    status: .enable
                )
            }
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .success:
            VStack(spacing: 16) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(.green)

                Text("Payment Successful")
                    .font(.title3.bold())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .cancelled:
            VStack(spacing: 16) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(.gray)

                Text("Payment Cancelled")
                    .font(.title3.bold())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
