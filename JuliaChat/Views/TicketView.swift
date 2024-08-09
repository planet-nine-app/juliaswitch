//
//  TicketView.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/9/24.
//

import SwiftUI
// 1. Import the SpriteKit framework
import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        createTicket()
    }
    
    func createTicket() {
        // 1. Create the sprite
        let trogdor = SKSpriteNode(imageNamed: "trogdor")
        let guitar = SKSpriteNode(imageNamed: "guitar")
        
        trogdor.xScale = 0.33
        trogdor.yScale = 0.33
        guitar.xScale = 0.25
        guitar.yScale = 0.25
                
        // 2. Set the initial position (left side of the screen)
        trogdor.position = CGPoint(x: -25, y: self.frame.midY)
        guitar.position = CGPoint(x: 500, y: self.frame.midY + 50)
                
        // 3. Add the sprite to the scene
        addChild(trogdor)
        addChild(guitar)
                
        // 4. Create the animation action
        let moveRight = SKAction.moveBy(x: self.frame.width + 50, y: 0, duration: 2.0)
        let moveLeft = SKAction.moveBy(x: -self.frame.width - 50, y: 0, duration: 2.0)
        
        let rightLeft = SKAction.sequence([moveRight, moveLeft])
        let leftRight = SKAction.sequence([moveLeft, moveRight])
        
        let rl = SKAction.repeatForever(rightLeft)
        let lr = SKAction.repeatForever(leftRight)
        
        // 5. Run the animation
        trogdor.run(rl)
        guitar.run(lr)
        
        theHorns()
    }
    
    func theHorns() {
        for index in 0...35 {
            // 1. Create a label with the emoji
            let emojiLabel = SKLabelNode(text: "🤘")
            emojiLabel.fontSize = 24  // Adjust size as needed
                    
            // 2. Convert the label to an SKSpriteNode
            let texture = view?.texture(from: emojiLabel)
            let sprite = SKSpriteNode(texture: texture)
                    
            // 3. Set the initial position (left side of the screen)
            sprite.position = CGPoint(x: CGFloat(Int.random(in: 0..<Int((self.frame.width)))), y: CGFloat(Int.random(in: -25..<25)))
                    
            // 4. Add the sprite to the scene
            addChild(sprite)
                    
            // 5. Create the animation action
            let moveUp = SKAction.moveBy(x: 0, y: self.frame.height, duration: 3.0)
                    
            // 6. Run the animation
            sprite.run(moveUp) {
                sprite.removeFromParent()
                if index > 34 {
                    self.theHorns()
                }
            }
        }
    }
}

struct TicketView: View {
    
    @State var playing = false
    
    // 2. Create a variable that will initialize and host the Game Scene
    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 1000, height: 1000)
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        ZStack {
            Button() {
                playing = !playing
            } label: {
                Text("SHOW TICKET")
            }
            // 3. Using the SpriteView, show the game scene in your SwiftUI view
            //    You can even use modifiers!
            if playing {
                SpriteView(scene: self.scene)
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

