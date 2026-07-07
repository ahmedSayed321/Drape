//
//  GenderPickerField.swift
//  Drape
//
//  Created by Moaz on 06/07/2026.
//
import SwiftUI

enum Gender: String, CaseIterable, Identifiable {
    case male = "Male"
    case female = "Female"

    var id: String { rawValue }
}

struct GenderPickerField: View {
    let title: String
    @Binding var selectedGender: Gender

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 16, weight: .medium))

            Menu {
                ForEach(Gender.allCases) { gender in
                    Button {
                        selectedGender = gender
                    } label: {
                        Text(gender.rawValue)
                    }
                }
            } label: {
                HStack {
                    Text(selectedGender.rawValue)
                        .foregroundStyle(Color(hex: "1A1A1A"))

                    Spacer()

                    Image(systemName: "chevron.down")
                        .foregroundStyle(.gray.opacity(0.7))
                }
                .padding(.horizontal, 12)
                .frame(height: 52)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            }
        }
    }
}

#Preview {
    GenderPickerField(title: "Gender", selectedGender: .constant(.male))
        .padding()
}
