//
//  ShopView.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 21.07.24.
//

import SwiftUI

struct ShopView: View {
    // MARK: - Property -
    @EnvironmentObject var appSettings: AppSettings
    @StateObject private var viewModel = ShopViewModel()

    // MARK: - Tab with background -
    var tabBackground: some View {
        TabView(selection: $viewModel.selectedPage) {
            ForEach(0..<((viewModel.backgrounds.count + 3) / 4), id: \.self) { index in
                VStack(spacing: 45) {
                    if index * 4 < viewModel.backgrounds.count {
                        HStack {
                            selectableImage(imageName: viewModel.backgrounds[index * 4])
                            if index * 4 + 1 < viewModel.backgrounds.count {
                                selectableImage(imageName: viewModel.backgrounds[index * 4 + 1])
                            }
                        }
                    }
                    if index * 4 + 2 < viewModel.backgrounds.count {
                        HStack {
                            selectableImage(imageName: viewModel.backgrounds[index * 4 + 2])
                            if index * 4 + 3 < viewModel.backgrounds.count {
                                selectableImage(imageName: viewModel.backgrounds[index * 4 + 3])
                            }
                        }
                    }
                }
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }

    // MARK: - Next button -
    var nextButton: some View {
        Button(action: {
            withAnimation {
                if viewModel.selectedPage < ((viewModel.backgrounds.count + 3) / 4) - 1 {
                    viewModel.selectedPage += 1
                }
            }
        }) {
            Image(.nextArrow)
        }
    }

    // MARK: - Back button -
    var backButton: some View {
        Button(action: {
            withAnimation {
                if viewModel.selectedPage > 0 {
                    viewModel.selectedPage -= 1
                }
            }
        }) {
            Image(.backArrow)
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
                Image(.shopLogo)
                    .padding(.top, 60)

                Spacer()

                HStack {
                    if viewModel.selectedPage > 0 {
                        backButton
                    }

                    tabBackground

                    if viewModel.selectedPage < ((viewModel.backgrounds.count + 3) / 4) - 1 {
                        nextButton
                    }
                }
                .padding(.horizontal, 20)

                Spacer()
            }

            if viewModel.showBuyBackground {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()

                BuyBackground(
                    imageBackground: viewModel.selectedBackgroundForPurchase ?? "",
                    isSufficientCoins: viewModel.isSufficientCoins,
                    closeVoid: {
                        viewModel.showBuyBackground = false
                    },
                    checkVoid: {
                        viewModel.purchaseBackground(appSettings: appSettings)
                    }
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !viewModel.showBuyBackground {
                    BackButton()
                }
            }
        }
    }

    // MARK: - Selected background -
    @ViewBuilder
    private func selectableImage(imageName: String) -> some View {
        let isSelected = appSettings.selectedBackground == imageName
        let isBlocked = !viewModel.purchasedBackgrounds.contains(imageName) && imageName != "Background"
        ZStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(isSelected ? LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom) : LinearGradient(colors: [.clear, .clear], startPoint: .top, endPoint: .bottom), lineWidth: 3)
                )
                .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.height / 4)
                .onTapGesture {
                    if isBlocked {
                        viewModel.selectBackgroundForPurchase(imageName)
                    } else {
                        appSettings.selectedBackground = imageName
                    }
                }
            if isBlocked {
                Image(.backgroundShadow)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(0.8)
                    .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.height / 4)
                Text(L10n.Shop.Title.block)
                    .font(.splineSansMonoBold(of: 18))
                    .foregroundColor(.white)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if isBlocked {
                viewModel.selectBackgroundForPurchase(imageName)
            } else {
                appSettings.selectedBackground = imageName
            }
        }
    }
}

#Preview {
    ShopView()
        .environmentObject(AppSettings())
}
