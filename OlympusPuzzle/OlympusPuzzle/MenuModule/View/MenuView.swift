//
//  MenuView.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 19.07.24.
//

import SwiftUI

struct MenuView: View {
    // MARK: - Property -
    @EnvironmentObject var appSettings: AppSettings
    
    // MARK: - Initialization -
    init() {
        AudioManager.shared.playBackgroundMusic()
    }
    
    // MARK: - Body -
    var body: some View {
        NavigationView {
            ZStack {
                if let savedBackground = appSettings.selectedBackground {
                    Image(savedBackground)
                        .resizable()
                        .ignoresSafeArea()
                } else {
                    Image(.background)
                        .resizable()
                        .ignoresSafeArea()
                }
                
                VStack {
                    Spacer()
                    
                    Image(.logoName)
                     
                    VStack(spacing: 30) {
                        AppButton(image: .playButton, destination: MonstersGameView())
                        AppButton(image: .levelsButton, destination: LevelsView())
                        AppButton(image: .shopButton, destination: ShopView())
                        AppButton(image: .settingsButton, destination: SettingsView())
                    }
                    .padding(.top, 64)
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        EmptyView()
                    } label: {
                        Image(.collectionButton)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 42, height: 42)
                    }
                }
            }
        }
    }
}

#Preview {
    MenuView()
        .environmentObject(AppSettings())
}
