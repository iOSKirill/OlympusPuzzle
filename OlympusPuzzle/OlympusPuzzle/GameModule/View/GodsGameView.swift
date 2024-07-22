//
//  GodsGameView.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 22.07.24.
//

import SpriteKit
import SwiftUI

class GodsGameScene: SKScene {
    // MARK: - Property -
    var hook: SKSpriteNode!
    var line: SKSpriteNode!
    var background: SKSpriteNode!
    
    var hookPositionY: CGFloat!
    var elementSpacing: CGFloat = 100.0
    var lastElementYPosition: CGFloat?
    
    var isHookMovingDown = false

    var godCoins = 0 {
        didSet {
            UserDefaults.standard.set(godCoins, forKey: "coins")
            NotificationCenter.default.post(name: .coinsUpdated, object: nil, userInfo: ["coins": godCoins])
        }
    }
    
    var roundGodCoins = 0 {
        didSet {
            NotificationCenter.default.post(name: .roundGodCoinsUpdated, object: nil, userInfo: ["roundGodCoins": roundGodCoins])
        }
    }

    var isGodGameOver = false {
        didSet {
            NotificationCenter.default.post(name: .godGameOver, object: nil)
        }
    }

    var currentGodLevel = UserDefaults.standard.integer(forKey: "currentGodLevel") {
        didSet {
            UserDefaults.standard.set(currentGodLevel, forKey: "currentGodLevel")
        }
    }
    
    var godCoinTarget: Int {
        return 10 + (currentGodLevel - 1) * 10
    }

    override func didMove(to view: SKView) {
        currentGodLevel = UserDefaults.standard.integer(forKey: "currentGodLevel")
         if currentGodLevel == 0 {
             currentGodLevel = 1 // Инициализация на 1 уровень, если значение 0
             UserDefaults.standard.set(currentGodLevel, forKey: "currentGodLevel")
         }
        
        isHookMovingDown = false
        lastElementYPosition = nil
        roundGodCoins = 0
        
        removeAllChildren()
        removeAllActions()
        setupScene()
    }
    
    func startNextGodLevel() {
        currentGodLevel += 1
        UserDefaults.standard.set(currentGodLevel, forKey: "currentGodLevel")
     
        isHookMovingDown = false
        lastElementYPosition = nil
        roundGodCoins = 0
        
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
        line.yScale = 1 // Начальный масштаб по Y
        addChild(line)
        
        // Setup hook
        hook = SKSpriteNode(imageNamed: "Hook")
        hook.setScale(0.8)
        hook.position = CGPoint(x: size.width / 2, y: size.height - line.size.height + 130)
        hookPositionY = hook.position.y
        addChild(hook)
        
        // Load saved god coins
        godCoins = UserDefaults.standard.integer(forKey: "coins")
        
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
        let elements = ["Diamond5", "Diamond6"]
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
        
        // Create the horizontal movement action
        let actionMove = SKAction.move(to: CGPoint(x: -element.size.width / 2, y: element.position.y), duration: TimeInterval(CGFloat.random(in: 4.0...6.0)))
        actionMove.timingMode = .easeInEaseOut
        
        // Create the rotation action
        let rotationDuration = CGFloat.random(in: 2.0...4.0)
        let rotateAction = SKAction.rotate(byAngle: .pi * 2, duration: TimeInterval(rotationDuration))
        
        // Combine movement and rotation
        let moveAndRotate = SKAction.group([actionMove, SKAction.repeatForever(rotateAction)])
        
        let actionRemove = SKAction.removeFromParent()
        element.run(SKAction.sequence([moveAndRotate, actionRemove]))
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
            
            let hookMoveDown = SKAction.moveTo(y: self.size.height - self.line.size.height * 5, duration: 0.3)
            let lineMoveDown = SKAction.scaleY(to: 5, duration: 0.3)
            
            hookMoveDown.timingMode = .easeInEaseOut
            lineMoveDown.timingMode = .easeInEaseOut
            
            let wait = SKAction.wait(forDuration: 0.1)
            
            let checkCollision = SKAction.run { [unowned self] in
                self.checkHookCollision()
            }
            
            let hookMoveUp = SKAction.moveTo(y: self.hookPositionY, duration: 0.15)
            let lineMoveUp = SKAction.scaleY(to: 1, duration: 0.15)
            
            hookMoveUp.timingMode = .easeInEaseOut
            lineMoveUp.timingMode = .easeInEaseOut
            
            let resetHook = SKAction.run { [unowned self] in
                self.isHookMovingDown = false
            }
            
            let hookSequence = SKAction.sequence([hookMoveDown, wait, checkCollision, hookMoveUp, resetHook])
            let lineSequence = SKAction.sequence([lineMoveDown, wait, lineMoveUp])
            
            hook.run(hookSequence)
            line.run(lineSequence)
        }
    }

    func checkHookCollision() {
        for element in children where element != hook && element != line && element.name != "background" && element.frame.intersects(hook.frame) {
            if element.name == "Enemy1" || element.name == "Enemy2" {
                // Set game over state
                isGodGameOver = true
                
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
                roundGodCoins += 10
                godCoins += 10
                NotificationCenter.default.post(name: .roundGodCoinsUpdated, object: nil, userInfo: ["roundGodCoins": roundGodCoins])
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
        isGodGameOver = false
        isHookMovingDown = false
        lastElementYPosition = nil
        roundGodCoins = 0
        
        removeAllChildren()
        removeAllActions()
        
        setupScene()
    }
}



struct GodsGameView: View {
    // MARK: - Property -
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var achievementsManager: AchievementsManager
    
    @State private var godCoins = UserDefaults.standard.integer(forKey: "coins")
    @State private var roundGodCoins = 0
    @State private var scene = GodsGameScene(size: CGSize(width: 300, height: 600))
    @State private var isGodGameOver = false
    @State private var timer: Timer?
    @State private var timeRemaining = 60
    @State private var isGodGameWin = false
    @State private var currentGodLevel = UserDefaults.standard.integer(forKey: "currentGodLevel")
    @State private var showAchieveView = false
    @State private var currentAchievement: Achievement?
    
    private let achievements: [Achievement] = [
        Achievement(
            imageName: "Aphrodite",
            title: L10n.Achieve.Title.aphrodite,
            subtitle: L10n.Achieve.Subtitle.aphrodite
        ),
        Achievement(
            imageName: "Zeus",
            title: L10n.Achieve.Title.zeus,
            subtitle: L10n.Achieve.Subtitle.zeus
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
            
            if isGodGameOver {
                GameOverView(isPresentedGameScreen: $isGodGameOver, isGameOver: $isGodGameOver)
            } else if isGodGameWin {
                GameWinView(startNextLevel: {
                    print("Current level: \(currentGodLevel), Achievements count: \(achievements.count)")
                    
                    if currentGodLevel == 0 {
                        currentGodLevel = 1
                        UserDefaults.standard.set(currentGodLevel, forKey: "currentGodLevel")
                    }
                    if achievements.indices.contains(currentGodLevel - 1) {
                        print("Index \(currentGodLevel - 1) is valid.")
                        currentAchievement = achievements[currentGodLevel - 1]
                    } else {
                        print("Index \(currentGodLevel - 1) is invalid, using default achievement.")
                        currentAchievement = Achievement(
                            imageName: "Zeus",
                            title: L10n.Achieve.Title.zeus,
                            subtitle: L10n.Achieve.Subtitle.zeus
                        )
                    }
                    showAchieveView = true
                })
            }
            
            if showAchieveView, let achievement = currentAchievement {
                AchieveView(
                    showAchieveView: $showAchieveView,
                    closeVoid: {
                        achievementsManager.addAchievementGod(achievement)
                        startNextGodLevel()
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
                if !isGodGameOver && !isGodGameWin {
                    BackButton()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if !isGodGameOver && !isGodGameWin {
                    ToolbarCoinView(coins: $godCoins)
                }
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: .coinsUpdated, object: nil, queue: .main) { notification in
                if let updatedGodCoins = notification.userInfo?["coins"] as? Int {
                    godCoins = updatedGodCoins
                }
            }
            NotificationCenter.default.addObserver(forName: .roundGodCoinsUpdated, object: nil, queue: .main) { notification in
                if let updatedRoundGodCoins = notification.userInfo?["roundGodCoins"] as? Int {
                    roundGodCoins = updatedRoundGodCoins
                }
            }
            NotificationCenter.default.addObserver(forName: .godGameOver, object: nil, queue: .main) { _ in
                isGodGameOver = true
                stopTimer()
            }
            NotificationCenter.default.addObserver(forName: .restartHeroGame, object: nil, queue: .main) { _ in
                isGodGameOver = false
                isGodGameWin = false
                scene.resetScene()
                startTimer()
            }
            NotificationCenter.default.addObserver(forName: .startNextGodLevel, object: nil, queue: .main) { _ in
                startNextGodLevel()
            }
            startTimer()
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: .coinsUpdated, object: nil)
            NotificationCenter.default.removeObserver(self, name: .roundGodCoinsUpdated, object: nil)
            NotificationCenter.default.removeObserver(self, name: .godGameOver, object: nil)
            NotificationCenter.default.removeObserver(self, name: .restartHeroGame, object: nil)
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
                checkGodGameOutcome()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func checkGodGameOutcome() {
        let targetGodCoins = scene.godCoinTarget
        print("Checking game outcome with roundGodCoins: \(roundGodCoins), godCoinTarget: \(targetGodCoins)")
        
        if roundGodCoins > targetGodCoins {
            print("Game win condition met.")
            isGodGameWin = true
            isGodGameOver = false
        } else {
            print("Game over condition met.")
            isGodGameWin = false
            isGodGameOver = true
        }
        
        // Логирование состояния игры
        print("isGodGameWin: \(isGodGameWin), isGodGameOver: \(isGodGameOver)")
        
        // Принудительное обновление интерфейса
        DispatchQueue.main.async {
            if self.isGodGameOver {
                NotificationCenter.default.post(name: .godGameOver, object: nil)
            }
        }
    }
    
    func startNextGodLevel() {
        currentGodLevel += 1
        UserDefaults.standard.set(currentGodLevel, forKey: "currentGodLevel")
        isGodGameWin = false
        isGodGameOver = false
        roundGodCoins = 0  // Reset roundGodCoins for the new level
        scene.currentGodLevel = currentGodLevel
        scene.startNextGodLevel()
        startTimer()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    GodsGameView()
}
