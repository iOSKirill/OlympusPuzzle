//
//  BuyBackground.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 21.07.24.
//

import SwiftUI

struct BuyBackground: View {
    // MARK: - Property -
    let imageBackground: String?
    let isSufficientCoins: Bool
    let closeVoid: () -> ()
    let checkVoid: () -> ()
    
    // MARK: - Body -
    var body: some View {
        VStack {
            if isSufficientCoins {
                Image(imageBackground ?? "")
                    .resizable()
                    .frame(maxWidth: 97, maxHeight: 210)
                    .padding(.top, 40)
                    .padding(.horizontal, 114)
                
                Text(L10n.Shop.Title.buy)
                    .font(.splineSansMonoRegular(of: 18))
                    .foregroundColor(.cFFFFFF)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 55)
                    .padding(.top, 20)
                
                Spacer()
                
                HStack(spacing: 63) {
                    Button {
                        closeVoid()
                    } label: {
                        Image(.noButton)
                    }
                    
                    Button {
                        checkVoid()
                    } label: {
                        Image(.yesButton)
                    }
                }
                .offset(y: 20)
            } else {
                Spacer()
                
                Text(L10n.Shop.Title.noCoins)
                    .font(.splineSansMonoRegular(of: 18))
                    .foregroundColor(.cFFFFFF)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 55)
                
                Spacer()
                
                Button {
                    closeVoid()
                } label: {
                    Image(.noButton)
                }
                .offset(y: 20)
            }
        }
        .frame(maxWidth: 325, maxHeight: 396)
        .background(
            Image(.backgorundShopAlert)
        )
    }
}

#Preview {
    BuyBackground(
        imageBackground: "",
        isSufficientCoins: false,
        closeVoid: {},
        checkVoid: {}
    )
}
