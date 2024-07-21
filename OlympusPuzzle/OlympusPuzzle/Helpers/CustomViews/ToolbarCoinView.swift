//
//  ToolbarCoinView.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 21.07.24.
//

import SwiftUI

struct ToolbarCoinView: View {
    // MARK: - Property -
    @Binding var coins: Int
    
    // MARK: - Body -
    var body: some View {
        ZStack {
            Image(.score)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 42)
            Text("\(coins)")
                .font(.splineSansMonoMedium(of: 20))
                .foregroundColor(.cFFFFFF)
                .padding(.leading, 20)
        }
    }
}
