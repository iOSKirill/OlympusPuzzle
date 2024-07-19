//
//  OlympusPuzzleApp.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 18.07.24.
//

import SwiftUI

@main
struct OlympusPuzzleApp: App {
    
    // MARK: - Initialization -
    init() {
        AudioManager.shared.playBackgroundMusic()
    }
    
    // MARK: - Body -
    var body: some Scene {
        WindowGroup {
            LaunchView()
        }
    }
}
