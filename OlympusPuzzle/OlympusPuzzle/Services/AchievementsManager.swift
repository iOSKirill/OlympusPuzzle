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
    @Published var achievementsHero: [Achievement] = UserDefaults.standard.loadHeroAchievements()
    @Published var achievementsGod: [Achievement] = UserDefaults.standard.loadGodAchievements()
    
    func addAchievement(_ achievement: Achievement) {
        achievements.append(achievement)
        UserDefaults.standard.saveAchievements(achievements)
    }
    
    func addAchievementHero(_ achievement: Achievement) {
        achievements.append(achievement)
        UserDefaults.standard.saveHeroAchievements(achievements)
    }
    
    func addAchievementGod(_ achievement: Achievement) {
        achievements.append(achievement)
        UserDefaults.standard.saveGodAchievements(achievements)
    }
}
