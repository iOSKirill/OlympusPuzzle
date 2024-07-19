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
    
    // MARK: - TabView onboarding -
    var tabViewOnboarding: some View {
        TabView(selection: $viewModel.currentStep) {
            ForEach(viewModel.onboardingSteps, id: \.id) { item in
                VStack {
                    ZStack(alignment: .bottomTrailing) {
                        Image(.rulesLogo)
                        if item.id == 0 {
                            Image(item.image)
                                .offset(x: 50, y: 50)
                        } else if  item.id == 1 {
                            Image(item.image)
                                .offset(x: 50, y: 40)
                        } else {
                            Image(item.image)
                                .offset(x: 50, y: 45)
                        }
                    }
                    VStack {
                        VStack {
                            Text(item.title)
                                .multilineTextAlignment(.center)
                                .font(.markoOneRegular(of: 16))
                                .foregroundColor(.cFFFFFF)
                        }
                        .padding(.top, 45)
                        .padding([.horizontal, .bottom], 20)
                    }
                    .frame(maxWidth: .infinity)
                    .background(.c092155.opacity(0.8))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.top, item.id == 0 ? 15 : 20)
                    Spacer()
                }
                .tag(item)
                .padding(.top, 149)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .animation(.easeInOut(duration: 0.3), value: viewModel.currentStep)
    }
    
    // MARK: - Next screen onboarding -
    var nextButton: some View {
        Button {
            viewModel.nextStepOnButton()
        } label: {
            Image(.nextButton)
        }
    }
    
    // MARK: - Body -
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                tabViewOnboarding
                nextButton
            }
        }
    }
}

#Preview {
    OnboardingView()
}
