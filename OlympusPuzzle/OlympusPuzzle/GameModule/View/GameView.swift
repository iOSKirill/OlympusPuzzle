//
//  GameView.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 19.07.24.
//

import SpriteKit
import SwiftUI

class GameScene: SKScene {
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
    
    var isGameOver = false {
        didSet {
            NotificationCenter.default.post(name: .gameOver, object: nil)
        }
    }

    override func didMove(to view: SKView) {
        setupScene()
    }

    func setupScene() {
        // Set up background image
        background = SKSpriteNode(imageNamed: "Background")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        background.size = size
        background.name = "background"
        addChild(background)
        
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
        let minY = element.size.height / 2
        let maxY = size.height / 2 - element.size.height / 2
        var yPosition: CGFloat
        
        // Generate position in the lower half of the screen
        yPosition = CGFloat.random(in: minY...maxY)

        // Ensure minimum spacing between elements
        if let lastY = lastElementYPosition {
            if abs(lastY - yPosition) < elementSpacing {
                yPosition = lastY - elementSpacing
                // Ensure element stays within screen bounds
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
                coins += 10
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
        
        removeAllChildren()
        removeAllActions()
        
        setupScene()
    }
}

struct GameView: View {
    // MARK: - Property -
    @State private var coins = UserDefaults.standard.integer(forKey: "coins")
    @State private var scene = GameScene(size: CGSize(width: 300, height: 600))
    @State private var isGameOver = false

    // MARK: - Body -
    var body: some View {
        NavigationView {
            ZStack {
                SpriteView(scene: scene)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                
                if isGameOver {
                    GameOverView(isPresentedGameScreen: $isGameOver, isGameOver: $isGameOver)
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    ToolbarCoinView(coins: $coins)
                }
            }
            .onAppear {
                NotificationCenter.default.addObserver(forName: .coinsUpdated, object: nil, queue: .main) { notification in
                    if let updatedCoins = notification.userInfo?["coins"] as? Int {
                        coins = updatedCoins
                    }
                }
                NotificationCenter.default.addObserver(forName: .gameOver, object: nil, queue: .main) { _ in
                    isGameOver = true
                }
                NotificationCenter.default.addObserver(forName: .restartGame, object: nil, queue: .main) { _ in
                    isGameOver = false
                    scene.resetScene()
                }
            }
            .onDisappear {
                NotificationCenter.default.removeObserver(self, name: .coinsUpdated, object: nil)
                NotificationCenter.default.removeObserver(self, name: .gameOver, object: nil)
                NotificationCenter.default.removeObserver(self, name: .restartGame, object: nil)
            }
        }
    }
}



struct GameOverView: View {
    @Binding var isPresentedGameScreen: Bool
    @Binding var isGameOver: Bool
    var body: some View {
        VStack {
            Text("Game Over")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Button {
                // Reset game state
                isPresentedGameScreen = false
                NotificationCenter.default.post(name: .restartGame, object: nil)
                isGameOver = false
            } label: {
                Text("Restart")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.8))
        .edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    GameView()
}
