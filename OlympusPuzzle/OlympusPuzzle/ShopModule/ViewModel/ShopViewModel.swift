//
//  ShopViewModel.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 21.07.24.
//

import Foundation

class ShopViewModel: ObservableObject {
    // MARK: - Property -
    @Published var selectedPage: Int = 0
    @Published var backgrounds: [String] = ["Background", "Background1", "Background2", "Background3", "Background4", "Background5", "Background6", "Background7"]
    @Published var purchasedBackgrounds: Set<String> = []
    @Published var showBuyBackground: Bool = false
    @Published var selectedBackgroundForPurchase: String?
    @Published var isSufficientCoins: Bool = true

    // Initialization
    init() {
        // Load purchased backgrounds from UserDefaults
        if let purchased = UserDefaults.standard.array(forKey: "purchasedBackgrounds") as? [String] {
            purchasedBackgrounds = Set(purchased)
        }
    }

    // Buy background
    func purchaseBackground(appSettings: AppSettings) {
        guard let imageName = selectedBackgroundForPurchase else { return }

        let currentCoins = UserDefaults.standard.integer(forKey: "coins")
        if currentCoins >= 10 {
            UserDefaults.standard.set(currentCoins - 10, forKey: "coins")
            purchasedBackgrounds.insert(imageName)
            UserDefaults.standard.set(Array(purchasedBackgrounds), forKey: "purchasedBackgrounds")
            appSettings.selectedBackground = imageName
            showBuyBackground = false
        } else {
            isSufficientCoins = false
        }
    }

    // Set background
    func selectBackgroundForPurchase(_ imageName: String) {
        selectedBackgroundForPurchase = imageName
        let currentCoins = UserDefaults.standard.integer(forKey: "coins")
        isSufficientCoins = currentCoins >= 10
        showBuyBackground = true
    }
}

