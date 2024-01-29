import SwiftUI
import SpriteKit

// GameScene represents the interactable environment where gameplay occurs. 
// SKPhysicsContactDelegate is a protocol used for handling contacts and collisions between physics bodies in a GameScene. 
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var rocket = SKSpriteNode()
    var rocketSize = CGSize(width: 50, height: 50)
    
    // Add a ground level to prevent the rocket from falling off the screen.
    var groundLevel = SKSpriteNode()
    var groundLevelSize = CGSize(width: 10000, height: 10)
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        // Reduce gravity slightly for this game. 
        physicsWorld.gravity = CGVector(dx: 0, dy: -0.9)
        
        rocket = SKSpriteNode(color: .cyan, size: rocketSize)
        // Place the rocket in the middle of the screen. 
        rocket.position = CGPoint(x: 300, y: 100)
        rocket.name = "rocket"
        rocket.physicsBody = SKPhysicsBody(rectangleOf: rocketSize)
        // Add the node to the GameScene. 
        addChild(rocket)
        
        groundLevel = SKSpriteNode(color: .brown, size: groundLevelSize)
        groundLevel.position = CGPoint(x: 300, y: 10)
        groundLevel.name = "groundLevel"
        groundLevel.physicsBody = SKPhysicsBody(rectangleOf: groundLevelSize)
        // Prevent the 'groundLevel' from moving. 
        groundLevel.physicsBody?.isDynamic = false
        addChild(groundLevel)
    }
}
