//
//  UserDefaults+Extension.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 22.07.24.
//

import Foundation

extension UserDefaults {
    private static let achievementsKey = "achievements"
    
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
}
