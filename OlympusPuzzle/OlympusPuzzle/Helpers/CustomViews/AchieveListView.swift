//
//  AchieveListView.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 22.07.24.
//

import SwiftUI

struct AchieveListView: View {
    // MARK: - Property -
    @EnvironmentObject var achievementsManager: AchievementsManager
    
    // MARK: - Body -
    var body: some View {
        NavigationView {
            List(achievementsManager.achievements, id: \.imageName) { achievement in
                HStack {
                    Image(achievement.imageName)
                        .resizable()
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading) {
                        Text(achievement.title)
                            .font(.headline)
                        Text(achievement.subtitle)
                            .font(.subheadline)
                    }
                }
            }
            .navigationBarTitle("Achievements")
        }
    }
}


#Preview {
    AchieveListView()
}
