import UIKit
import SceneKit

class ViewController: UIViewController {

    var sceneView: SCNView!
    var earth: SCNNode!
    var moon: SCNNode!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
    }

    func setupScene() {
        sceneView = SCNView()
        sceneView.frame = view.bounds
        sceneView.backgroundColor = .black
        sceneView.allowsCameraControl = true
        view.addSubview(sceneView)

        let scene = SCNScene()
        sceneView.scene = scene

        sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))

        let sun = SCNNode()
        sun.position = SCNVector3Make(-500, 0, 0)
        sun.light = SCNLight()
        sun.light!.type = .omni
        scene.rootNode.addChildNode(sun)

        let earthGeometry = SCNSphere(radius: 10)
        earthGeometry.materials.first!.diffuse.contents = UIImage(named: "earth.png")
        earth = SCNNode(geometry: earthGeometry)
        earth.position = SCNVector3Make(0, 0, 0)
        scene.rootNode.addChildNode(earth)

        let moonRotator = SCNNode()
        moonRotator.position = SCNVector3Make(0, 0, 0)
        scene.rootNode.addChildNode(moonRotator)

        let moonGeometry = SCNSphere(radius: 2.5)
        moonGeometry.materials.first!.diffuse.contents = UIImage(named: "moon.jpg")
        moon = SCNNode(geometry: moonGeometry)
        moon.position = SCNVector3Make(50, 0, 0)
        moonRotator.addChildNode(moon)

        let moonOrbit = CABasicAnimation(keyPath: "rotation")
        moonOrbit.fromValue = moonRotator.rotation
        moonOrbit.toValue = SCNVector4Make(0, 1, 0, 2 * .pi)
        moonOrbit.duration = 3 * 28
        moonOrbit.repeatCount = .infinity
        moonRotator.addAnimation(moonOrbit, forKey: "rotation")

        let earthRotation = CABasicAnimation(keyPath: "rotation")
        earthRotation.fromValue = earth.rotation
        earthRotation.toValue = SCNVector4Make(0, 1, 0, 2 * .pi)
        earthRotation.duration = 3
        earthRotation.repeatCount = .infinity
        earth.addAnimation(earthRotation, forKey: "rotation")
    }

    @objc func handleTap(_ tap: UITapGestureRecognizer) {
        sceneView.scene!.isPaused = !sceneView.scene!.isPaused
    }

}
