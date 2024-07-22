//
//  AchieveView.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 22.07.24.
//

import SwiftUI

struct AchieveView: View {
    // MARK: - Property -
    @Binding var showAchieveView: Bool
    @Environment(\.dismiss) var dismiss
    let closeVoid: () -> ()
    let image: String
    let title: String
    let subtitle: String
    
    // MARK: - Body -
    var body: some View {
        ZStack {
            Image(.backgroundAchieve)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                ZStack(alignment: .top) {
                    VStack {
                        ZStack(alignment: .bottom) {
                            Image(image)
                            
                            HStack {
                                Image(.listLeft)
                                    .offset(x: 35)
                                Spacer()
                                Image(.listRight)
                                    .offset(x: -35)
                            }
                            .offset(y: 20)
                            
                            Image(.newAchieveLogo)
                                .offset(y: 30)
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Button {
                            closeVoid()
                            showAchieveView = false
                        } label: {
                            Image(.noButton)
                        }
                        .padding(.trailing, 30)
                        .offset(y: -25)
                    }
                }
                
                VStack(spacing: 15) {
                    Text(title)
                        .font(.splineSansMonoBold(of: 28))
                        .foregroundColor(.cFFFFFF)
                    Text(subtitle)
                        .font(.splineSansMonoRegular(of: 14))
                        .foregroundColor(.cFFFFFF)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 30)
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
}


#Preview {
    AchieveView(
        showAchieveView: .constant(false),
        closeVoid: {},
        image: "Zeus",
        title: L10n.Achieve.Title.zeus,
        subtitle: L10n.Achieve.Subtitle.zeus
    )
}
