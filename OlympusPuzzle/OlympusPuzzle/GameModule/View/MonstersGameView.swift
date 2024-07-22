//
//  MonstersGameView.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 19.07.24.
//

import SpriteKit
import SwiftUI

class MonstersGameScene: SKScene {
    // MARK: - Property -
    var hook: SKSpriteNode!
    var line: SKSpriteNode!
    var background: SKSpriteNode!
    
    var hookPositionY: CGFloat!
    var elementSpacing: CGFloat = 100.0
    var lastElementYPosition: CGFloat?
    
    var isHookMovingDown = false

    var coins = 0 {
        didSet {
            UserDefaults.standard.set(coins, forKey: "coins")
            NotificationCenter.default.post(name: .coinsUpdated, object: nil, userInfo: ["coins": coins])
        }
    }
    
    var roundCoins = 0 {
        didSet {
            NotificationCenter.default.post(name: .roundCoinsUpdated, object: nil, userInfo: ["roundCoins": roundCoins])
        }
    }

    var isGameOver = false {
        didSet {
            NotificationCenter.default.post(name: .gameOver, object: nil)
        }
    }

    var currentLevel = UserDefaults.standard.integer(forKey: "currentLevel") {
        didSet {
            UserDefaults.standard.set(currentLevel, forKey: "currentLevel")
        }
    }
    
    var coinTarget: Int {
        return 10 + (currentLevel - 1) * 10
    }

    override func didMove(to view: SKView) {
        currentLevel = UserDefaults.standard.integer(forKey: "currentLevel")
         if currentLevel == 0 {
             currentLevel = 1 // Инициализация на 1 уровень, если значение 0
             UserDefaults.standard.set(currentLevel, forKey: "currentLevel")
         }
        
        isHookMovingDown = false
        lastElementYPosition = nil
        roundCoins = 0
        
        removeAllChildren()
        removeAllActions()
        setupScene()
    }
    
    func startNextLevel() {
        currentLevel += 1
        UserDefaults.standard.set(currentLevel, forKey: "currentLevel")
     
        isHookMovingDown = false
        lastElementYPosition = nil
        roundCoins = 0
        
        removeAllChildren()
        removeAllActions()
        setupScene()
    }

    func setupScene() {
        // Set up background image
        updateBackground()
        
        // Setup line
        line = SKSpriteNode(imageNamed: "FishingLine")
        line.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        line.position = CGPoint(x: size.width / 2, y: size.height + 150)
        addChild(line)
        
        // Setup hook
        hook = SKSpriteNode(imageNamed: "Hook")
        hook.setScale(0.8)
        hook.position = CGPoint(x: size.width / 2, y: size.height - line.size.height + 130)
        hookPositionY = hook.position.y
        addChild(hook)
        
        // Setup coin label
        
        // Load saved coins
        coins = UserDefaults.standard.integer(forKey: "coins")
        
        // Spawn elements
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(spawnElement),
                SKAction.wait(forDuration: 1.5)
            ])
        ))
    }
    
    @objc func updateBackground() {
         let savedBackground = UserDefaults.standard.string(forKey: "selectedBackground") ?? "Background"
         
         if background != nil {
             background.removeFromParent()
         }
         
         background = SKSpriteNode(imageNamed: savedBackground)
         background.position = CGPoint(x: size.width / 2, y: size.height / 2)
         background.zPosition = -1
         background.size = size
         background.name = "background"
         addChild(background)
     }

    func spawnElement() {
        let elements = ["Diamond1", "Diamond2"]
        let harmfulElements = ["Enemy1", "Enemy2"]
        
        // Adjust probability: 80% chance for regular elements, 20% for harmful elements
        let elementName: String
        if Int.random(in: 1...100) <= 80 { // 80% chance for diamonds
            elementName = elements.randomElement()!
        } else { // 20% chance for enemies
            elementName = harmfulElements.randomElement()!
        }
        
        let element = SKSpriteNode(imageNamed: elementName)
        element.name = elementName
        element.setScale(0.7)
        let yPosition = generateElementYPosition(for: element)
        element.position = CGPoint(x: size.width + element.size.width / 2, y: yPosition)
        addChild(element)
        
        let actionMove = SKAction.move(to: CGPoint(x: -element.size.width / 2, y: element.position.y), duration: TimeInterval(CGFloat.random(in: 4.0...6.0)))
        let actionRemove = SKAction.removeFromParent()
        element.run(SKAction.sequence([actionMove, actionRemove]))
    }

    func generateElementYPosition(for element: SKSpriteNode) -> CGFloat {
        // Определяем диапазон для позиции Y элементов
        let hookY = hook.position.y
        let elementHeight = element.size.height
        let minY = max(elementHeight / 2, hookY - elementSpacing)
        let maxY = min(size.height - elementHeight / 2, hookY + elementSpacing)
        
        // Убедимся, что minY не превышает maxY
        if minY > maxY {
            return hookY // если диапазон некорректный, возвращаем текущую позицию крючка
        }

        var yPosition: CGFloat
        
        // Генерируем случайную позицию в пределах диапазона
        yPosition = CGFloat.random(in: minY...maxY)

        // Обеспечиваем минимальное расстояние между элементами
        if let lastY = lastElementYPosition {
            if abs(lastY - yPosition) < elementSpacing {
                yPosition = lastY - elementSpacing
                // Убеждаемся, что элемент остается в пределах экрана
                if yPosition - element.size.height / 2 < minY {
                    yPosition = minY
                }
            }
        }
        lastElementYPosition = yPosition
        
        return yPosition
    }



    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isHookMovingDown {
            isHookMovingDown = true
            let moveDown = SKAction.run { [unowned self] in
                self.line.yScale = 5.0
                self.hook.position = CGPoint(x: self.hook.position.x, y: self.size.height - self.line.size.height * 5)
            }
            let wait = SKAction.wait(forDuration: 0.5)
            let checkCollision = SKAction.run { [unowned self] in
                self.checkHookCollision()
            }
            let moveUp = SKAction.run { [unowned self] in
                self.line.yScale = 1.0
                self.hook.position = CGPoint(x: self.hook.position.x, y: self.hookPositionY)
                self.isHookMovingDown = false
            }
            hook.run(SKAction.sequence([moveDown, wait, checkCollision, moveUp]))
        }
    }

    func checkHookCollision() {
        for element in children where element != hook && element != line && element.name != "background" && element.frame.intersects(hook.frame) {
            if element.name == "Enemy1" || element.name == "Enemy2" {
                // Set game over state
                isGameOver = true
                
                // Remove the line
                self.line.removeFromParent()
                
                // Create and position the cut line image
                let cutLine = SKSpriteNode(imageNamed: "LoseFishingLine")
                cutLine.setScale(0.8)
                cutLine.position = CGPoint(x: size.width / 2, y: frame.minY + 110)
                addChild(cutLine)
                
                // Remove the hook
                hook.removeFromParent()
            } else {
                // Regular element collected
                element.removeFromParent()
                roundCoins += 10
                coins += 10
                NotificationCenter.default.post(name: .roundCoinsUpdated, object: nil, userInfo: ["roundCoins": roundCoins])
            }
            break
        }
    }

    override func update(_ currentTime: TimeInterval) {
        if isHookMovingDown {
            checkHookCollision()
        }
        for element in children where element != hook && element != line && element.name != "background" {
            if let spriteElement = element as? SKSpriteNode {
                if spriteElement.position.x < -spriteElement.size.width / 2 {
                    spriteElement.removeFromParent()
                }
            }
        }
    }

    func resetScene() {
        isGameOver = false
        isHookMovingDown = false
        lastElementYPosition = nil
        roundCoins = 0
        
        removeAllChildren()
        removeAllActions()
        
        setupScene()
    }
}

struct MonstersGameView: View {
    // MARK: - Property -
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var achievementsManager: AchievementsManager
    
    @State private var coins = UserDefaults.standard.integer(forKey: "coins")
    @State private var roundCoins = 0
    @State private var scene = MonstersGameScene(size: CGSize(width: 300, height: 600))
    @State private var isGameOver = false
    @State private var timer: Timer?
    @State private var timeRemaining = 60
    @State private var isGameWin = false
    @State private var currentLevel = UserDefaults.standard.integer(forKey: "currentLevel")
    @State private var showAchieveView = false
    @State private var currentAchievement: Achievement?
    
    private let achievements: [Achievement] = [
        Achievement(
            imageName: "Jellyfish",
            title: L10n.Achieve.Title.meduse,
            subtitle: L10n.Achieve.Subtitle.meduse
        ),
        Achievement(
            imageName: "Nymph",
            title: L10n.Achieve.Title.nymph,
            subtitle: L10n.Achieve.Subtitle.nymph
        ),
    ]
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                ZStack {
                    Image(.time)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 55)
                        .padding(.bottom, 20)
                    
                    Text("\(timeFormatted(timeRemaining))")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding(.leading, 40)
                        .padding(.bottom, 20)
                }
            }
            
            if isGameOver {
                GameOverView(isPresentedGameScreen: $isGameOver, isGameOver: $isGameOver)
            } else if isGameWin {
                GameWinView(startNextLevel: {
                    print("Current level: \(currentLevel), Achievements count: \(achievements.count)")
                    
                    if currentLevel == 0 {
                        currentLevel = 1
                        UserDefaults.standard.set(currentLevel, forKey: "currentLevel")
                    }
                    if achievements.indices.contains(currentLevel - 1) {
                        print("Index \(currentLevel - 1) is valid.")
                        currentAchievement = achievements[currentLevel - 1]
                    } else {
                        print("Index \(currentLevel - 1) is invalid, using default achievement.")
                        currentAchievement = Achievement(
                            imageName: "Nymph",
                            title: L10n.Achieve.Title.nymph,
                            subtitle: L10n.Achieve.Subtitle.nymph
                        )
                    }
                    showAchieveView = true
                })
            }
            
            if showAchieveView, let achievement = currentAchievement {
                AchieveView(
                    showAchieveView: $showAchieveView,
                    closeVoid: {
                        achievementsManager.addAchievement(achievement)
                        startNextLevel()
                    },
                    image: achievement.imageName,
                    title: achievement.title,
                    subtitle: achievement.subtitle
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !isGameOver && !isGameWin {
                    BackButton()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if !isGameOver && !isGameWin {
                    ToolbarCoinView(coins: $coins)
                }
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: .coinsUpdated, object: nil, queue: .main) { notification in
                if let updatedCoins = notification.userInfo?["coins"] as? Int {
                    coins = updatedCoins
                }
            }
            NotificationCenter.default.addObserver(forName: .roundCoinsUpdated, object: nil, queue: .main) { notification in
                if let updatedRoundCoins = notification.userInfo?["roundCoins"] as? Int {
                    roundCoins = updatedRoundCoins
                }
            }
            NotificationCenter.default.addObserver(forName: .gameOver, object: nil, queue: .main) { _ in
                isGameOver = true
                stopTimer()
            }
            NotificationCenter.default.addObserver(forName: .restartGame, object: nil, queue: .main) { _ in
                isGameOver = false
                isGameWin = false
                scene.resetScene()
                startTimer()
            }
            NotificationCenter.default.addObserver(forName: .startNextLevel, object: nil, queue: .main) { _ in
                startNextLevel()
            }
            startTimer()
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: .coinsUpdated, object: nil)
            NotificationCenter.default.removeObserver(self, name: .roundCoinsUpdated, object: nil)
            NotificationCenter.default.removeObserver(self, name: .gameOver, object: nil)
            NotificationCenter.default.removeObserver(self, name: .restartGame, object: nil)
            stopTimer()
        }
    }
    
    func startTimer() {
        timeRemaining = 60
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
                checkGameOutcome()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func checkGameOutcome() {
        let targetCoins = scene.coinTarget
        print("Checking game outcome with roundCoins: \(roundCoins), coinTarget: \(targetCoins)")
        
        if roundCoins > targetCoins {
            print("Game win condition met.")
            isGameWin = true
            isGameOver = false
        } else {
            print("Game over condition met.")
            isGameWin = false
            isGameOver = true
        }
        
        // Логирование состояния игры
        print("isGameWin: \(isGameWin), isGameOver: \(isGameOver)")
        
        // Принудительное обновление интерфейса
        DispatchQueue.main.async {
            if self.isGameOver {
                NotificationCenter.default.post(name: .gameOver, object: nil)
            }
        }
    }
    
    func startNextLevel() {
        currentLevel += 1
        UserDefaults.standard.set(currentLevel, forKey: "currentLevel")
        isGameWin = false
        isGameOver = false
        roundCoins = 0  // Reset roundCoins for the new level
        scene.currentLevel = currentLevel
        scene.startNextLevel()
        startTimer()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    MonstersGameView()
}
