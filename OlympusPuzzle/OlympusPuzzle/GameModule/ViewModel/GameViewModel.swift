//
//  GameViewModel.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 19.07.24.
//

import SwiftUI

class GameViewModel: ObservableObject {
    // MARK: - Property -
    @Published var pulse = false
    
    // Start anamation pulsing
    func startPulsing() {
        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            pulse.toggle()
        }
    }
}
