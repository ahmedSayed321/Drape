//
//  PhoneNumberField.swift
//  Drape
//
//  Created by Moaz on 06/07/2026.
//
import SwiftUI

struct CountryCode: Identifiable {
    let id = UUID()
    let flag: String
    let dialCode: String
    let name: String
}

extension CountryCode {
    static let all: [CountryCode] = [
        CountryCode(flag: "🇺🇸", dialCode: "+1", name: "United States"),
        CountryCode(flag: "🇪🇬", dialCode: "+20", name: "Egypt"),
        CountryCode(flag: "🇬🇧", dialCode: "+44", name: "United Kingdom"),
        CountryCode(flag: "🇸🇦", dialCode: "+966", name: "Saudi Arabia"),
        CountryCode(flag: "🇦🇪", dialCode: "+971", name: "UAE")
    ]
}

struct PhoneNumberField: View {
    let title: String
    @Binding var selectedCountry: CountryCode
    @Binding var phoneNumber: String
    @FocusState private var isTyping: Bool
    @State private var showCountryPicker = false

    private var borderColor: Color {
        isTyping ? .black : .gray.opacity(0.4)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 16, weight: .medium))

            HStack(spacing: 0) {
                Button {
                    showCountryPicker = true
                } label: {
                    HStack(spacing: 4) {
                        Text(selectedCountry.flag)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.gray.opacity(0.7))
                    }
                }
                .buttonStyle(.plain)
                .padding(.trailing, 8)

                Divider()
                    .frame(height: 24)
                    .padding(.trailing, 8)

                Text(selectedCountry.dialCode)
                    .foregroundStyle(Color(hex: "1A1A1A"))
                    .padding(.trailing, 4)

                TextField("234 453 231 506", text: $phoneNumber)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.plain)
                    .focused($isTyping)
            }
            .padding(.horizontal, 12)
            .frame(height: 52)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: isTyping ? 2 : 1)
            )
            .animation(.easeInOut(duration: 0.2), value: isTyping)
        }
        .sheet(isPresented: $showCountryPicker) {
            NavigationStack {
                List(CountryCode.all) { country in
                    Button {
                        selectedCountry = country
                        showCountryPicker = false
                    } label: {
                        HStack {
                            Text(country.flag)
                            Text(country.name)
                                .foregroundStyle(Color(hex: "1A1A1A"))
                            Spacer()
                            Text(country.dialCode)
                                .foregroundStyle(.gray)
                        }
                    }
                }
                .navigationTitle("Select Country")
                .navigationBarTitleDisplayMode(.inline)
            }
            .presentationDetents([.medium])
        }
    }
}

#Preview {
    PhoneNumberField(
        title: "Phone Number",
        selectedCountry: .constant(CountryCode.all[0]),
        phoneNumber: .constant("")
    )
    .padding()
}
