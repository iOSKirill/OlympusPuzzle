//
//  OlympusPuzzleApp.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 18.07.24.
//

import SwiftUI

@main
struct OlympusPuzzleApp: App {
    // MARK: - Property -
    @StateObject private var appSettings = AppSettings()
    
    // MARK: - Body -
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(appSettings)
        }
    }
}
