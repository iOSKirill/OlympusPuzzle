//
//  AchieveListView.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 22.07.24.
//

import SwiftUI

struct AchieveListView: View {
    // MARK: - Property -
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var achievementsManager: AchievementsManager
    
    @State private var showAchieveView: Bool = false
    @State private var selectedAchievement: Achievement?

    @State private var showAchieveView2: Bool = false
    @State private var selectedAchievement2: Achievement?

    @State private var showAchieveView3: Bool = false
    @State private var selectedAchievement3: Achievement?
    
    // State to track the current index
    @State private var currentIndex: Int = 0
    @State private var currentIndex2: Int = 0
    @State private var currentIndex3: Int = 0

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
                Image(.collectionLogo)
                    .padding(.top, 16)
                VStack {
                    Text(L10n.AchieveList.Title.monsters)
                        .font(.splineSansMonoBold(of: 30))
                        .foregroundColor(.c481571)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Array(achievementsManager.achievements.enumerated()), id: \.1.imageName) { index, achievement in
                                    VStack {
                                        Image(achievement.imageName)
                                            .resizable()
                                            .frame(width: 98, height: 98)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom), lineWidth: 5)
                                            )
                                            .cornerRadius(10)
                                            .onTapGesture {
                                                selectedAchievement = achievement
                                                showAchieveView = true
                                            }
                                    }
                                    .padding(.horizontal, 13)
                                    .id(index) // Assign ID for each item
                                }
                                
                                ForEach(0..<7, id: \.self) { index in
                                    Image(.clearAchievmentLogo)
                                        .padding(.horizontal, 13)
                                        .id(achievementsManager.achievements.count + index) // Assign ID for placeholder items
                                }
                            }
                        }
                        .onChange(of: currentIndex) { index in
                            withAnimation {
                                proxy.scrollTo(index, anchor: .center)
                            }
                        }
                    }
                    
                    HStack(spacing: 25) {
                        Button {
                            if currentIndex > 0 {
                                currentIndex = max(currentIndex - 3, 0)
                            }
                        } label: {
                            Image(.backArrow)
                        }
                        
                        Button {
                            if currentIndex < achievementsManager.achievements.count + 6 { // Include placeholder items
                                currentIndex = min(currentIndex + 3, achievementsManager.achievements.count + 6)
                            }
                        } label: {
                            Image(.nextArrow)
                        }
                    }
                    .padding(.top, 15)
                }
                .padding(.top, 25)
                .padding(.horizontal, 20)
                
                // Second ScrollView
                VStack {
                    Text(L10n.AchieveList.Title.heroes)
                        .font(.splineSansMonoBold(of: 30))
                        .foregroundColor(.c481571)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Array(achievementsManager.achievementsHero.enumerated()), id: \.1.imageName) { index, achievement in
                                    VStack {
                                        Image(achievement.imageName)
                                            .resizable()
                                            .frame(width: 98, height: 98)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom), lineWidth: 5)
                                            )
                                            .cornerRadius(10)
                                            .onTapGesture {
                                                selectedAchievement2 = achievement
                                                showAchieveView2 = true
                                            }
                                    }
                                    .padding(.horizontal, 13)
                                    .id(index) // Assign ID for each item
                                }
                                
                                ForEach(0..<7, id: \.self) { index in
                                    Image(.clearAchievmentLogo)
                                        .padding(.horizontal, 13)
                                        .id(achievementsManager.achievementsHero.count + index) // Assign ID for placeholder items
                                }
                            }
                        }
                        .onChange(of: currentIndex2) { index in
                            withAnimation {
                                proxy.scrollTo(index, anchor: .center)
                            }
                        }
                    }
                    
                    HStack(spacing: 25) {
                        Button {
                            if currentIndex2 > 0 {
                                currentIndex2 = max(currentIndex2 - 3, 0)
                            }
                        } label: {
                            Image(.backArrow)
                        }
                        
                        Button {
                            if currentIndex2 < achievementsManager.achievementsHero.count + 6 { // Include placeholder items
                                currentIndex2 = min(currentIndex2 + 3, achievementsManager.achievementsHero.count + 6)
                            }
                        } label: {
                            Image(.nextArrow)
                        }
                    }
                    .padding(.top, 15)
                }
                .padding(.top, 25)
                .padding(.horizontal, 20)
                
                // Third ScrollView
                VStack {
                    Text(L10n.AchieveList.Title.gods)
                        .font(.splineSansMonoBold(of: 30))
                        .foregroundColor(.c481571)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Array(achievementsManager.achievementsGod.enumerated()), id: \.1.imageName) { index, achievement in
                                    VStack {
                                        Image(achievement.imageName)
                                            .resizable()
                                            .frame(width: 98, height: 98)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom), lineWidth: 5)
                                            )
                                            .cornerRadius(10)
                                            .onTapGesture {
                                                selectedAchievement3 = achievement
                                                showAchieveView3 = true
                                            }
                                    }
                                    .padding(.horizontal, 13)
                                    .id(index) // Assign ID for each item
                                }
                                
                                ForEach(0..<7, id: \.self) { index in
                                    Image(.clearAchievmentLogo)
                                        .padding(.horizontal, 13)
                                        .id(achievementsManager.achievementsGod.count + index) // Assign ID for placeholder items
                                }
                            }
                        }
                        .onChange(of: currentIndex3) { index in
                            withAnimation {
                                proxy.scrollTo(index, anchor: .center)
                            }
                        }
                    }
                    
                    HStack(spacing: 25) {
                        Button {
                            if currentIndex3 > 0 {
                                currentIndex3 = max(currentIndex3 - 3, 0)
                            }
                        } label: {
                            Image(.backArrow)
                        }
                        
                        Button {
                            if currentIndex3 < achievementsManager.achievementsGod.count + 6 { // Include placeholder items
                                currentIndex3 = min(currentIndex3 + 3, achievementsManager.achievementsGod.count + 6)
                            }
                        } label: {
                            Image(.nextArrow)
                        }
                    }
                    .padding(.top, 15)
                }
                .padding(.top, 25)
                .padding(.horizontal, 20)
                
                Spacer()
            }
            if showAchieveView, let achievement = selectedAchievement {
                AchieveView(
                    showAchieveView: $showAchieveView,
                    closeVoid: { showAchieveView = false },
                    image: achievement.imageName,
                    title: achievement.title,
                    subtitle: achievement.subtitle
                )
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }
            if showAchieveView2, let achievement = selectedAchievement2 {
                AchieveView(
                    showAchieveView: $showAchieveView2,
                    closeVoid: { showAchieveView2 = false },
                    image: achievement.imageName,
                    title: achievement.title,
                    subtitle: achievement.subtitle
                )
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }
            if showAchieveView3, let achievement = selectedAchievement3 {
                AchieveView(
                    showAchieveView: $showAchieveView3,
                    closeVoid: { showAchieveView3 = false },
                    image: achievement.imageName,
                    title: achievement.title,
                    subtitle: achievement.subtitle
                )
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !showAchieveView && !showAchieveView2 && !showAchieveView3 {
                    BackButton()
                }
            }
        }
    }
}





#Preview {
    AchieveListView()
        .environmentObject(AppSettings())
        .environmentObject(AchievementsManager())
}
