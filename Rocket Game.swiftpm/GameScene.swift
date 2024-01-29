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
    
    var spinnyNode: SKShapeNode?
    
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
        rocket.physicsBody?.mass = 1
        rocket.physicsBody?.angularDamping = 1.5
        // Add the node to the GameScene. 
        addChild(rocket)
        
        groundLevel = SKSpriteNode(color: .brown, size: groundLevelSize)
        groundLevel.position = CGPoint(x: 300, y: 10)
        groundLevel.name = "groundLevel"
        groundLevel.physicsBody = SKPhysicsBody(rectangleOf: groundLevelSize)
        // Prevent the 'groundLevel' from moving. 
        groundLevel.physicsBody?.isDynamic = false
        addChild(groundLevel)
        
        // Use a 'spinnyNode' to highlight where the player has tapped. 
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeOut(withDuration: 0.5), SKAction.removeFromParent()]))
        }
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
            
            // Add orange visual thruster feedback to the rocket if turned right. 
            let thrusterParticle = SKSpriteNode(color: .orange, size: CGSize(width: 5, height: 5))
            thrusterParticle.position = rocket.position
            addChild(thrusterParticle)
            
            // Add orange visual tap feedback if turned right. 
            if let n = self.spinnyNode?.copy() as! SKShapeNode? {
                n.position = location
                n.strokeColor = SKColor.orange
                self.addChild(n)
            }
        } else if location.x < -100 + rocket.position.x {
            // If the player is touching 100 pixels to the left of the rocket, then rotate the rocket to the left. 
            rocket.physicsBody?.applyAngularImpulse(rocketThrustAngularImpulse)
            
            // Add red visual thruster feedback to the rocket if turned left.
            let thrusterParticle = SKSpriteNode(color: .red, size: CGSize(width: 5, height: 5))
            thrusterParticle.position = rocket.position
            addChild(thrusterParticle)
            
            // Add red visual tap feedback if turned right. 
            if let n = self.spinnyNode?.copy() as! SKShapeNode? {
                n.position = location
                n.strokeColor = SKColor.red
                self.addChild(n)
            }
        } else {
            // If the player is touching in between, then move the rocket forward.
            rocket.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
            
            // Add blue visual thruster feedback to the rocket if going straight.
            let thrusterParticle = SKSpriteNode(color: .blue, size: CGSize(width: 5, height: 5))
            thrusterParticle.position = rocket.position
            addChild(thrusterParticle)
            
            // Add blue visual tap feedback if turned right. 
            if let n = self.spinnyNode?.copy() as! SKShapeNode? {
                n.position = location
                n.strokeColor = SKColor.blue
                self.addChild(n)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        rocketCamera.position = rocket.position
    }
}
