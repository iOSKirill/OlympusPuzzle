//
//  LaunchViewModel.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 18.07.24.
//

import SwiftUI
import Combine

// MARK: - Enum onboarding -
enum AppCondition: String {
    case onboarding
    case menu
}

class LaunchViewModel: ObservableObject {
    // MARK: - Property -
    @AppStorage("appCondition") var appCondition: AppCondition?
    
    @Published var isActive = false
    @Published var pulse = false
    
    private var cancellable: AnyCancellable?
    
    // Initialization
    init() {
        startTimer()
    }
    
    // Start timer from next screen
    func startTimer() {
        cancellable = Just(())
            .delay(for: .seconds(3), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.isActive = true
            }
    }
    
    // Start anamation pulsing
    func startPulsing() {
        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            pulse.toggle()
        }
    }
}
