//
//  BackButton.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 19.07.24.
//

import SwiftUI

struct BackButton: View {
    // MARK: - Property -
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body -
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(.backButton)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 42, height: 42)
        }
    }
}

#Preview {
    BackButton()
}
