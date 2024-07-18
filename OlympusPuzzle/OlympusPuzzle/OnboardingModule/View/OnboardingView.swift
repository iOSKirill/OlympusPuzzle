//
//  OnboardingView.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 18.07.24.
//

import SwiftUI

struct OnboardingView: View {
    // MARK: - Property -
    @StateObject private var viewModel = OnboardingViewModel()
    
    // MARK: - Body -
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
             
            }
        }
    }
}

#Preview {
    OnboardingView()
}
