import UIKit
import SpriteKit

class ViewController: UIViewController {

    var spriteView: SKView!
    var monster: SKNode!
    var ball: SKNode!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSprites()
    }

    func setupSprites() {
        spriteView = SKView()
        spriteView.frame = view.bounds
        view.addSubview(spriteView)

        let scene = SKScene(size: spriteView.bounds.size)
        scene.backgroundColor = .white
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spriteView.presentScene(scene)

        spriteView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))

        monster = SKSpriteNode(imageNamed: "monster.png")
        monster.position = CGPoint(x: 0, y: 0)
        monster.setScale(0.5)
        scene.addChild(monster)

        ball = SKSpriteNode(imageNamed: "ball.png")
        ball.position = CGPoint(x: 250, y: 70)
        ball.setScale(0.75)
        scene.addChild(ball)

        ball.physicsBody = SKPhysicsBody(circleOfRadius:
            max(ball.frame.size.width, ball.frame.size.height) / 2)
        ball.physicsBody!.affectedByGravity = true
        ball.physicsBody!.usesPreciseCollisionDetection = true
        ball.physicsBody!.restitution = 0.75
        ball.physicsBody!.isDynamic = false

        let floor = SKSpriteNode()
        floor.size = CGSize(width: 5000, height: 1)
        floor.position = CGPoint(x: ball.position.x - 500, y: ball.position.y - 350)
        spriteView.scene!.addChild(floor)

        floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
        floor.physicsBody!.isDynamic = false
    }

    @objc func handleTap(_ tap: UITapGestureRecognizer) {
        let spin = SKAction.applyAngularImpulse(-0.1, duration: 0.5)
        ball.run(spin)
        ball.physicsBody!.isDynamic = true
    }

}
