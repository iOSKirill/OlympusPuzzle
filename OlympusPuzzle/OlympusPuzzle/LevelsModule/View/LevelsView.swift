//
//  LevelsView.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 21.07.24.
//

import SwiftUI

struct LevelsView: View {
    // MARK: - Property -
    @EnvironmentObject var appSettings: AppSettings
    
    // MARK: - Monsters buttom -
    var mostersButton: some View {
        NavigationLink(destination: MonstersGameView()) {
            Image(.monstersButton)
        }
    }
    
    // MARK: - Heroes buttom -
    var heroesButton: some View {
        NavigationLink(destination: HeroesGameView()) {
            Image(.heroesButton)
        }
    }
    
    // MARK: - Gods buttom -
    var godsButton: some View {
        NavigationLink(destination: GodsGameView()) {
            Image(.godsButton)
        }
    }
    
    // MARK: - Body -
    var body: some View {
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
                Image(.selectLevelLogo)
                    .padding(.top, 70)
                
                VStack(spacing: 25) {
                    mostersButton
                    heroesButton
                    godsButton
                }
                .padding(.top, 70)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton()
            }
        }
    }
}

#Preview {
    LevelsView()
        .environmentObject(AppSettings())
}
