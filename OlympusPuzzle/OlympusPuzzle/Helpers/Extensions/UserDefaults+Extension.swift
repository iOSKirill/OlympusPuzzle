//
//  UserDefaults+Extension.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 22.07.24.
//

import Foundation

extension UserDefaults {
    
    private static let achievementsKey = "achievements"
    private static let heroAchievementsKey = "heroAchievements"
    private static let godAchievementsKey = "godAchievements"
    
    func saveAchievements(_ achievements: [Achievement]) {
        if let encoded = try? JSONEncoder().encode(achievements) {
            set(encoded, forKey: UserDefaults.achievementsKey)
        }
    }
    
    func loadAchievements() -> [Achievement] {
        if let savedData = data(forKey: UserDefaults.achievementsKey),
           let savedAchievements = try? JSONDecoder().decode([Achievement].self, from: savedData) {
            return savedAchievements
        }
        return []
    }
        
    func saveHeroAchievements(_ achievements: [Achievement]) {
        if let encoded = try? JSONEncoder().encode(achievements) {
            set(encoded, forKey: UserDefaults.heroAchievementsKey)
        }
    }
    
    func loadHeroAchievements() -> [Achievement] {
        if let savedData = data(forKey: UserDefaults.heroAchievementsKey),
           let savedAchievements = try? JSONDecoder().decode([Achievement].self, from: savedData) {
            return savedAchievements
        }
        return []
    }
     
     func saveGodAchievements(_ achievements: [Achievement]) {
         if let encoded = try? JSONEncoder().encode(achievements) {
             set(encoded, forKey: UserDefaults.godAchievementsKey)
         }
     }
     
     func loadGodAchievements() -> [Achievement] {
         if let savedData = data(forKey: UserDefaults.godAchievementsKey),
            let savedAchievements = try? JSONDecoder().decode([Achievement].self, from: savedData) {
             return savedAchievements
         }
         return []
     }
}
