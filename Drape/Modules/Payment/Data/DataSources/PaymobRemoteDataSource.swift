//
//  PaymobRemoteDataSource.swift
//  Drape
//

import Foundation

protocol PaymobRemoteDataSourceProtocol {
    func authenticate() async throws -> PaymobAuthResponseDTO
    func createOrder(_ request: PaymobOrderRequestDTO) async throws -> PaymobOrderResponseDTO
    func createPaymentKey(_ request: PaymobPaymentKeyRequestDTO) async throws -> PaymobPaymentKeyResponseDTO
}

final class PaymobRemoteDataSource: PaymobRemoteDataSourceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func authenticate() async throws -> PaymobAuthResponseDTO {
        try await post(.auth, body: PaymobAuthRequestDTO(apiKey: PaymobConfig.apiKey))
    }

    func createOrder(_ request: PaymobOrderRequestDTO) async throws -> PaymobOrderResponseDTO {
        try await post(.createOrder, body: request)
    }

    func createPaymentKey(_ request: PaymobPaymentKeyRequestDTO) async throws -> PaymobPaymentKeyResponseDTO {
        try await post(.paymentKey, body: request)
    }

    private func post<Response: Decodable, Body: Encodable>(
        _ endpoint: PaymobEndpoint,
        body: Body
    ) async throws -> Response {
        guard let url = endpoint.url else {
            throw PaymentError.invalidConfiguration
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        request.httpBody = try encoder.encode(body)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw PaymentError.network("Invalid server response.")
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw PaymentError.gateway(message: decodeErrorMessage(from: data), statusCode: httpResponse.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw PaymentError.decoding
        }
    }

    private func decodeErrorMessage(from data: Data) -> String {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        if let error = try? decoder.decode(PaymobErrorResponseDTO.self, from: data) {
            return error.detail ?? error.message ?? error.error ?? "Payment gateway request failed."
        }

        return String(data: data, encoding: .utf8) ?? "Payment gateway request failed."
    }
}
