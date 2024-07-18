//
//  LaunchView.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 18.07.24.
//

import SwiftUI

struct LaunchView: View {
    // MARK: - Property -
    @StateObject private var viewModel = LaunchViewModel()
    
    // MARK: - Body -
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image(.logoName)
                    .padding(.horizontal, 16)
                    .offset(y: 60)
                    .scaleEffect(viewModel.pulse ? 1.0 : 0.9)
                    .onAppear {
                        viewModel.startPulsing()
                    }
                
                Spacer()
                
                Image(.launchBottom)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFit()
            }
        }
        .onAppear {
            viewModel.startTimer()
        }
        .fullScreenCover(isPresented: $viewModel.isActive) {
            EmptyView()
        }
    }
}

#Preview {
    LaunchView()
}
