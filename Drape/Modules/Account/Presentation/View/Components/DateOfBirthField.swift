//
//  DateOfBirthField.swift
//  Drape
//
//  Created by Moaz on 06/07/2026.
//
import SwiftUI

struct DateOfBirthField: View {
    let title: String
    @Binding var date: Date
    @State private var showPicker = false
    @FocusState private var isFocused: Bool

    private var borderColor: Color {
        showPicker ? .black : .gray.opacity(0.4)
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 16, weight: .medium))

            Button {
                showPicker.toggle()
            } label: {
                HStack {
                    Text(formattedDate)
                        .foregroundStyle(Color(hex: "1A1A1A"))

                    Spacer()

                    Image(systemName: "calendar")
                        .foregroundStyle(.gray.opacity(0.7))
                }
                .padding(.horizontal, 12)
                .frame(height: 52)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor, lineWidth: showPicker ? 2 : 1)
                )
            }
            .buttonStyle(.plain)
            .animation(.easeInOut(duration: 0.2), value: showPicker)
        }
        .sheet(isPresented: $showPicker) {
            VStack {
                DatePicker(
                    "Select Date of Birth",
                    selection: $date,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()

                Button {
                    showPicker = false
                } label: {
                    Text("Done")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(hex: "1A1A1A"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .presentationDetents([.height(340)])
        }
    }
}

#Preview {
    DateOfBirthField(title: "Date of Birth", date: .constant(Date()))
        .padding()
}
