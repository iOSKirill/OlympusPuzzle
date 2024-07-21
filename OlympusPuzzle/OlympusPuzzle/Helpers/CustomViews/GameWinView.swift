//
//  GameWinView.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 22.07.24.
//

import SwiftUI

struct GameWinView: View {
    // MARK: - Property -
    @StateObject private var viewModel = GameViewModel()
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body -
    var body: some View {
        ZStack {
            Image(.backgroundWin)
                .resizable()
                .ignoresSafeArea()
                .offset(x: -0.5)
                
            VStack {
                Spacer()
                
                Image(.youWinLogo)
                    .scaleEffect(viewModel.pulse ? 1.0 : 0.9)
                    .onAppear {
                        viewModel.startPulsing()
                    }
                
                Spacer()
                
                VStack(spacing: 25) {
                    Button {
                        dismiss()
                    
                    } label: {
                        Image(.menuButton)
                    }
                    
                    Image(.orLogo)
                    
                    Button {
                        
                    } label: {
                        Image(.nextButton)
                    }
                }
                .padding(.bottom, 90)
            }
        }
    }
}

#Preview {
    GameWinView()
}
