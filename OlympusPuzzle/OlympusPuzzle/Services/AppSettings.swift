//
//  AppSettings.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 21.07.24.
//

import Foundation

class AppSettings: ObservableObject {
    @Published var selectedBackground: String? {
        didSet {
            if let selectedBackground = selectedBackground {
                UserDefaults.standard.set(selectedBackground, forKey: "selectedBackground")
            }
        }
    }
    
    init() {
        self.selectedBackground = UserDefaults.standard.string(forKey: "selectedBackground") ?? "Background"
    }
}
