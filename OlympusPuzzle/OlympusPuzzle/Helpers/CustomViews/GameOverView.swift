//
//  GameOverView.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 21.07.24.
//

import SwiftUI

struct GameOverView: View {
    // MARK: - Property -
    @StateObject private var viewModel = GameViewModel()
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresentedGameScreen: Bool
    @Binding var isGameOver: Bool
    
    // MARK: - Body -
    var body: some View {
        ZStack {
            Image(.backgroundLightning)
                .resizable()
                .ignoresSafeArea()
                .offset(x: -0.5)
                
            VStack {
                
                Spacer()
                
                Image(.timeIsOverLogo)
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
                        isPresentedGameScreen = false
                        NotificationCenter.default.post(name: .restartGame, object: nil)
                        isGameOver = false
                    } label: {
                        Image(.tryAgainButton)
                    }
                }
                .padding(.bottom, 90)
            }
        }
    }
}


#Preview {
    GameOverView(
        isPresentedGameScreen: .constant(false),
        isGameOver: .constant(false)
    )
}
