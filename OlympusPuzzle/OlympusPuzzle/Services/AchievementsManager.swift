//
//  AchievementsManager.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 22.07.24.
//

import Foundation
import Combine

class AchievementsManager: ObservableObject {
    @Published var achievements: [Achievement] = UserDefaults.standard.loadAchievements()
    
    func addAchievement(_ achievement: Achievement) {
        achievements.append(achievement)
        UserDefaults.standard.saveAchievements(achievements)
    }
}
