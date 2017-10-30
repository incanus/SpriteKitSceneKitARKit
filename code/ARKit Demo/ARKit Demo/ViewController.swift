import UIKit
import ARKit

class ViewController: UIViewController, ARSKViewDelegate, ARSCNViewDelegate {

    let BASE_VIEW = ARSCNView.self // change this between ARSKView & ARSCNView to swap kits

    var arSpriteView: ARSKView!
    var arSceneView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupARSession()
    }

    func setupARSession() {
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("ARKit is not available on this device.")
        }

        if BASE_VIEW == ARSKView.self {
            arSpriteView = ARSKView(frame: view.bounds)
            arSpriteView.delegate = self
            view.addSubview(arSpriteView)

            let scene = SKScene(size: arSpriteView.bounds.size)
            scene.scaleMode = .resizeFill
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            arSpriteView.presentScene(scene)

            let configuration = ARWorldTrackingConfiguration()
            arSpriteView.session.run(configuration, options: [])

            arSpriteView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        } else if BASE_VIEW == ARSCNView.self {
            arSceneView = ARSCNView(frame: view.bounds)
            arSceneView.autoenablesDefaultLighting = true
            arSceneView.delegate = self
            view.addSubview(arSceneView)

            let configuration = ARWorldTrackingConfiguration()
            arSceneView.session.run(configuration, options: [])

            arSceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        }
    }

    @objc func handleTap(_ tap: UITapGestureRecognizer) {
        if BASE_VIEW == ARSKView.self {
            if let _ = arSpriteView.hitTest(tap.location(in: tap.view), types: [.estimatedHorizontalPlane]).first {
                // detect the closest tapped horizontal plane, then set the sprite anchor two meters in front of the current camera position & orientation
                var translation = matrix_identity_float4x4
                translation.columns.3.z = -2
                let transform = simd_mul(arSpriteView.session.currentFrame!.camera.transform, translation)
                let anchor = ARAnchor(transform: transform)
                arSpriteView.session.add(anchor: anchor)
            }
        } else if BASE_VIEW == ARSCNView.self {
            if let hit = arSceneView.hitTest(tap.location(in: tap.view), types: [.estimatedHorizontalPlane]).first {
                // detect the closest tapped horizontal plane, then set the geometry anchor at the tap point
                let transform = hit.worldTransform
                let anchor = ARAnchor(transform: transform)
                arSceneView.session.add(anchor: anchor)
            }
        }
    }

    // only used for SpriteKit
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        let sprite = SKSpriteNode(imageNamed: "monster.png")
        return sprite
    }

    // only used for SceneKit
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let cube = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
        cube.firstMaterial!.diffuse.contents = UIColor.blue
        let node = SCNNode(geometry: cube)
        node.simdTransform = anchor.transform
        return node
    }

}
