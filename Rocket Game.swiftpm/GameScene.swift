import SwiftUI
import SpriteKit

// GameScene represents the interactable environment where gameplay occurs. 
class GameScene: SKScene {
    
    var node = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        node = SKSpriteNode(color: .cyan, size: CGSize(width: 50, height: 50))
        // Add the node to the GameScene. 
        addChild(node)
    }
}
