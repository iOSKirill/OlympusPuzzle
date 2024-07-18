//
//  OnboardingViewModel.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 18.07.24.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    // MARK: - Property -
    @Published var currentStep: Int = 0
    @Published var onboardingSteps = [
        OnboardingStep(id: 0,
                       title: ""),
        OnboardingStep(id: 1,
                       title: ""),
        OnboardingStep(id: 2,
                       title: "")
    ]
    
    // Next step onboarding -
    func nextStepOnButton() {
        if currentStep < onboardingSteps.count - 1 {
            currentStep += 1
        } else {
            
        }
    }
}
