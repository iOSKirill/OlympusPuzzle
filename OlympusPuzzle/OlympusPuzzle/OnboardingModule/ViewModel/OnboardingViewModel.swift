//
//  OnboardingViewModel.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 18.07.24.
//

import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    // MARK: - Property -
    @AppStorage("appCondition", store: .standard) var appCondition: AppCondition = .onboarding
    
    @Published var currentStep: Int = 0
    @Published var onboardingSteps = [
        OnboardingStep(id: 0,
                       image: .monstersLogo,
                       title: L10n.Onboarding.Title.first),
        OnboardingStep(id: 1,
                       image: .heroesLogo,
                       title: L10n.Onboarding.Title.second),
        OnboardingStep(id: 2,
                       image: .godsLogo,
                       title: L10n.Onboarding.Title.third)
    ]
    
    // Next step onboarding -
    func nextStepOnButton() {
        if currentStep < onboardingSteps.count - 1 {
            currentStep += 1
        } else {
            appCondition = .menu
        }
    }
}
