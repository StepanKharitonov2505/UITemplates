//
//  SceneKitViewController.swift
//  MyTestApp
//
//  Created by  user on 09.06.2023.
//

import UIKit
import SceneKit
import SnapKit

class SceneKitViewController: UIViewController {
  
  // MARK: Scene properties

  var sceneView = SCNView(frame: .zero)
  var scnScene: SCNScene!
  var cameraNode: SCNNode!
  var ambientLight: SCNNode!
  var spotLightBottomRight: SCNNode!
  var spotLightBottomLeft: SCNNode!
  var spotLightFront: SCNNode!
  lazy var matrix: SCNMatrix4 = {
    var matrix = SCNMatrix4Identity
    return matrix
  }()
  
  // MARK: PanGesture Recognize
  
  private let panGestureRecognizer = UIPanGestureRecognizer()
  private var panGestureLocation: CGPoint?
  
  // MARK: Life cycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
      self.view.backgroundColor = SingletonColorManager.shared.colorScheme.darkMainColor
      
      
      sceneView.backgroundColor = .clear
      sceneView.isJitteringEnabled = true
      sceneView.antialiasingMode = .multisampling4X
      
      view.addSubview(sceneView)
      setupScene()
      setupSceneViewConstraint()
      setupCamera()
      setupLight()
      setupTargetToSceneView()
      
    }
  
  // MARK: Private func
  
  private func setupScene() {
    scnScene = SCNScene(named: "SceneKitAssetCatalog.scnassets/SSLogoScnFormat.scn")
    
    let ssLogoNode = scnScene.rootNode.childNode(withName: "Cylinder", recursively: true)!
    ssLogoNode.position = SCNVector3(x: 0, y: 0, z: 0)
    ssLogoNode.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(0), y: GLKMathDegreesToRadians(0), z: GLKMathDegreesToRadians(0))
    ssLogoNode.scale = SCNVector3(x: 1, y: 1, z: 1)
    sceneView.scene = scnScene
  }
    
  private func setupCamera() {
    cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.eulerAngles = SCNVector3Make(GLKMathDegreesToRadians(-90), GLKMathDegreesToRadians(90), GLKMathDegreesToRadians(0))
    cameraNode.position = SCNVector3Make(0, 5, 0)
    cameraNode.scale = SCNVector3Make(1, 1, 1)
    cameraNode.camera?.usesOrthographicProjection = true
    cameraNode.camera?.orthographicScale = 2.5
    
    sceneView.scene?.rootNode.addChildNode(cameraNode)
    sceneView.pointOfView = cameraNode
  }
  
  private func setupLight() {
    ambientLight = SCNNode()
    universalSetupLight(ambientLight, type: .ambient, parentSCView: sceneView)
    
    spotLightFront = SCNNode()
    universalSetupLight(spotLightFront, type: .ambient, position: SCNVector3Make(0, 0, 15), parentSCView: sceneView, lookAtTarget: scnScene.rootNode.childNode(withName: "Cylinder", recursively: true))
    
    spotLightBottomRight = SCNNode()
    universalSetupLight(spotLightBottomRight, type: .spot, intensity: 1500, enableShadows: true, position: SCNVector3Make(5, -3, 1), parentSCView: sceneView, lookAtTarget: scnScene.rootNode.childNode(withName: "Cylinder", recursively: true))

    spotLightBottomLeft = SCNNode()
    universalSetupLight(spotLightBottomLeft, type: .spot, intensity: 500, enableShadows: true, position: SCNVector3Make(-3, -3, 0.5), parentSCView: sceneView, lookAtTarget: scnScene.rootNode.childNode(withName: "Cylinder", recursively: true))
  }
  
  private func universalSetupLight(_ lightNode: SCNNode,
                                   type: SCNLight.LightType,
                                   intensity: CGFloat = 1000,
                                   enableShadows: Bool = false,
                                   shadowRadius: CGFloat = 1,
                                   position: SCNVector3 = SCNVector3Make(0, 0, 0),
                                   eulerAngle: SCNVector3 = SCNVector3Make(GLKMathDegreesToRadians(0), GLKMathDegreesToRadians(0), GLKMathDegreesToRadians(0)),
                                   scale: SCNVector3 = SCNVector3Make(1, 1, 1),
                                   parentSCView: SCNView,
                                   lookAtTarget: SCNNode? = nil) {
    lightNode.light = SCNLight()
    lightNode.light?.type = type
    lightNode.light?.intensity = intensity
    lightNode.light?.castsShadow = enableShadows
    lightNode.light?.shadowMode = .forward
    lightNode.light?.shadowRadius = shadowRadius
    lightNode.position = position
    lightNode.eulerAngles = eulerAngle
    lightNode.scale = scale
    if lookAtTarget != nil {
      lightNode.constraints = [SCNLookAtConstraint(target: lookAtTarget)]
    }
    parentSCView.scene?.rootNode.addChildNode(lightNode)
  }
  
  private func refreshMatrix(duration: Double, node: SCNNode) {
    let identityMatrix = SCNMatrix4Identity
    
    
    let springAnimation = CASpringAnimation(keyPath: "transform")
    springAnimation.fromValue = node.transform
    springAnimation.toValue = identityMatrix
    springAnimation.damping = 6
    springAnimation.initialVelocity = 0.3
    springAnimation.duration = duration
    springAnimation.isCumulative = true
    springAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    // вот это удаляем, тк из-за этого дальнейшие взаимодействия с node не отображаются
//    springAnimation.fillMode = .forwards
//    springAnimation.isRemovedOnCompletion = false
    node.addAnimation(springAnimation, forKey: "transform")
    
    // это чтобы применить финальное состояние к ноде
    CATransaction.begin()
    node.transform = identityMatrix
    CATransaction.commit()
    
    if !SCNMatrix4EqualToMatrix4(matrix, identityMatrix) {
      matrix = identityMatrix
    }
  }
  
  // MARK: Constraints
  
  private func setupSceneViewConstraint() {
    sceneView.snp.makeConstraints { cstr in
      cstr.center.equalTo(view.snp.center)
      cstr.left.equalTo(view.snp.left)
      cstr.right.equalTo(view.snp.right)
      cstr.height.equalTo(view.snp.height).multipliedBy(0.3)
    }
  }
  
  // MARK: Setup Target
  
  private func setupTargetToSceneView() {
    panGestureRecognizer.addTarget(self, action:  #selector(handlePanGesture(_:)))
    panGestureRecognizer.maximumNumberOfTouches = 1
    sceneView.addGestureRecognizer(panGestureRecognizer)
  }
    
}

// MARK: PanGesture Recognize Method

extension SceneKitViewController {
  @objc private func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
    guard panGestureRecognizer === gestureRecognizer else { assert(false); return }
    let ssLogoNode = sceneView.scene!.rootNode.childNode(withName: "Cylinder", recursively: true)
    
    switch gestureRecognizer.state {
    case .began:
      // удаляем анимации
      ssLogoNode?.removeAllAnimations()
      matrix = ssLogoNode!.presentation.transform
      assert(panGestureLocation == nil)
      panGestureLocation = gestureRecognizer.location(in: sceneView)
      
      
    case .changed:
      
      guard let panGestureLocation = panGestureLocation else { assert(false); return }
      let gesturePoint = gestureRecognizer.location(in: sceneView)
      let ratioMovementXToHalfWidthScreen = (gesturePoint.x - panGestureLocation.x) / (sceneView.bounds.width / 2)
      let angleX: Float = ( -.pi / 2 ) * Float(ratioMovementXToHalfWidthScreen)
      let rotate3dX = SCNMatrix4Rotate(matrix, angleX, 1, 0, 0)
      
      let ratioMovementYToHalfHeightScreen = (gesturePoint.y - panGestureLocation.y) / (sceneView.bounds.height / 2)
      let angleY: Float = ( -.pi / 4 ) * Float(ratioMovementYToHalfHeightScreen)
      let rotate3dY = SCNMatrix4Rotate(matrix, angleY, 0, 0, 1)
      
      ssLogoNode!.transform = SCNMatrix4Mult(rotate3dX, rotate3dY)

    case .cancelled, .ended:
      refreshMatrix(duration: 1.5, node: ssLogoNode!)
      panGestureLocation = nil
      
    case .failed, .possible:
      assert(panGestureLocation == nil)
      break
      
    @unknown default:
      break
    }
  }
}
