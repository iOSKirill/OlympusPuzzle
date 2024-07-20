//
//  GameView.swift
//  OlympusPuzzle
//
//  Created by Kirill Manuilenko on 19.07.24.
//

import SpriteKit
import SwiftUI

extension Notification.Name {
    static let coinsUpdated = Notification.Name("coinsUpdated")
}

class GameScene: SKScene {
    // MARK: - Property -
    var hook: SKSpriteNode!
    var line: SKSpriteNode!
    var coinLabel: SKLabelNode!
    var background: SKSpriteNode!
    
    var hookPositionY: CGFloat!
    var elementSpacing: CGFloat = 100.0
    var lastElementYPosition: CGFloat?
    
    var coins = 0 {
        didSet {
            coinLabel.text = "\(coins)"
            UserDefaults.standard.set(coins, forKey: "coins")
            NotificationCenter.default.post(name: .coinsUpdated, object: nil, userInfo: ["coins": coins])
        }
    }
    var isHookMovingDown = false

    override func didMove(to view: SKView) {
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
        coinLabel = SKLabelNode(fontNamed: "Chalkduster")
        coinLabel.fontSize = 40
        coinLabel.fontColor = SKColor.white
        coinLabel.text = "0"
        
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
        let allElements = elements + harmfulElements
        
        // Adjust probability: 80% chance for regular elements, 20% for harmful elements
        let elementName: String
        if Bool.random() { // Randomly choose between 80% and 20%
            elementName = elements.randomElement()!
        } else {
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
        let safeAreaBelowHook = hookPositionY - hook.size.height / 2 - elementSpacing
        var yPosition: CGFloat
        
        // Generate position below the hook
        yPosition = CGFloat.random(in: 0...safeAreaBelowHook)
        
        // Ensure element doesn't go below the screen
        if yPosition - element.size.height / 2 < 0 {
            yPosition = element.size.height / 2
        }

        // Ensure minimum spacing between elements
        if let lastY = lastElementYPosition {
            if abs(lastY - yPosition) < elementSpacing {
                yPosition = lastY + elementSpacing
                // Ensure element stays within screen bounds
                if yPosition + element.size.height / 2 > size.height {
                    yPosition = size.height - element.size.height / 2
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
}


struct ToolbarCoinView: View {
    @Binding var coins: Int
    
    var body: some View {
        ZStack {
            Image(.score)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 42)
            Text("\(coins)")
                .font(.splineSansMonoMedium(of: 20))
                .foregroundColor(.cFFFFFF)
                .padding(.leading, 20)
        }
    }
}

struct GameView: View {
    // MARK: - Property -
    @StateObject private var viewModel = GameViewModel()
    @State private var coins = UserDefaults.standard.integer(forKey: "coins")
    
    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 300, height: 600)
        scene.scaleMode = .aspectFill
        return scene
    }
    
    // MARK: - Body -
    var body: some View {
        NavigationView {
            ZStack {
                SpriteView(scene: scene)
                    .frame(width: .infinity, height: .infinity)
                    .ignoresSafeArea()
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
            }
            .onDisappear {
                NotificationCenter.default.removeObserver(self, name: .coinsUpdated, object: nil)
            }
        }
    }
}

#Preview {
    GameView()
}
