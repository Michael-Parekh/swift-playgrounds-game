import SwiftUI
import SpriteKit

// GameScene represents the interactable environment where gameplay occurs. 
// SKPhysicsContactDelegate is a protocol used for handling contacts and collisions between physics bodies in a GameScene. 
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var rocket = SKSpriteNode()
    var rocketSize = CGSize(width: 50, height: 50)
    var rocketThrustAngularImpulse = 0.005
    var rocketXThrust = CGFloat(40)
    var rocketYThrust = CGFloat(115)
    var rocketCamera = SKCameraNode()
    
    // Add a ground level to prevent the rocket from falling off the screen.
    var groundLevel = SKSpriteNode()
    var groundLevelSize = CGSize(width: 10000, height: 10)
    
    // Where the user has tapped on the screen - used for determining the rocket movement. 
    var touchLocation = CGPoint()
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        // Reduce gravity slightly for this game. 
        physicsWorld.gravity = CGVector(dx: 0, dy: -0.9)
        
        // Keep the camera focused on the rocket as it moves by using SKCameraNode. 
        self.camera = rocketCamera
        
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
    
    // The user can control the rocket by tapping on the screen.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchLocation = touch.location(in: self)
        fireThrusters(location: touchLocation)
    }
    
    func fireThrusters(location: CGPoint) {
        let adjustedRotation = rocket.zRotation + (CGFloat.pi / 2)
        let dx = rocketXThrust * cos(adjustedRotation)
        let dy = rocketYThrust * sin(adjustedRotation)
        
        if location.x > 100 + rocket.position.x {
            // If the player is touching 100 pixels to the right of the rocket, then rotate the rocket to the right. 
            rocket.physicsBody?.applyAngularImpulse(-rocketThrustAngularImpulse)
        } else if location.x < -100 + rocket.position.x {
            // If the player is touching 100 pixels to the left of the rocket, then rotate the rocket to the left. 
            rocket.physicsBody?.applyAngularImpulse(rocketThrustAngularImpulse)
        } else {
            // If the player is touching in between, then move the rocket forward.
            rocket.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        rocketCamera.position = rocket.position
    }
}
