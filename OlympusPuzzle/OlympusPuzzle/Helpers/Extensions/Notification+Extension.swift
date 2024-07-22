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
}
