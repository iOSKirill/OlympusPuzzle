//
//  Notification+Extension.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 21.07.24.
//

import Foundation

extension Notification.Name {
    static let coinsUpdated = Notification.Name("coinsUpdated")
    static let gameOver = Notification.Name("gameOver")
    static let restartGame = Notification.Name("restartGame")
    static let roundCoinsUpdated = Notification.Name("roundCoinsUpdated")
    static let startNextLevel = Notification.Name("startNextLevel")
    
    static let heroGameOver = Notification.Name("heroGameOver")
    static let restartHeroGame = Notification.Name("restartHeroGame")
    static let roundHeroCoinsUpdated = Notification.Name("roundHeroCoinsUpdated")
    static let startNextHeroLevel = Notification.Name("startNextHeroLevel")
    
    static let godGameOver = Notification.Name("godGameOver")
    static let restartGodGame = Notification.Name("restartGodGame")
    static let roundGodCoinsUpdated = Notification.Name("roundGodCoinsUpdated")
    static let startNextGodLevel = Notification.Name("startNextGodLevel")
}
