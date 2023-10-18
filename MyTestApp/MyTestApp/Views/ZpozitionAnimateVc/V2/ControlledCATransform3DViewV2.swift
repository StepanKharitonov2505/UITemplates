//
//  ControlledCATransform3DViewV2.swift
//  MyTestApp
//
//  Created by  user on 09.09.2023.
//
import UIKit
import SnapKit

class ControlledCATransform3DViewV2: UIView {
  
  // MARK: Refresh Button
  
  let ssMainColor = UIColor.rgb(51, 106, 242)

  // MARK: CATransform3DView
  
  let perspective: CGFloat = -1 / 700
  lazy var matrixPozitionView: CATransform3D = {
    var transform3D = CATransform3DIdentity
    transform3D.m34 = perspective
    caTransform3DView.layer.sublayerTransform = transform3D
    return transform3D
  }()
  
  var caTransform3DView = UIView()
  
  var layerLevel1 = CALayer()
  var layerLevel2 = CALayer()
  var layerLevel3 = CALayer()
  
  var transformLayer = CATransformLayer()

  let CATransform3DViewSize: CGFloat = 250

  // MARK: Gesture Recognizers
  
  private let panGestureRecognizer = UIPanGestureRecognizer()
  private var panGestureAnchorPoint: CGPoint?
  
  // MARK: Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    setupGestureRecognizers()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
    setupGestureRecognizers()
  }
  
  // MARK: Load UI
  
  private func configureUI() {
    self.backgroundColor = SingletonColorManager.shared.colorScheme.darkMainColor
    
    self.addSubview(caTransform3DView)
    //caTransform3DView.translatesAutoresizingMaskIntoConstraints = false
    caTransform3DView.backgroundColor = .clear
    
    makeConstraints()
    configureLayers()
    
    caTransform3DView.layer.addSublayer(transformLayer)
  }
  
  // MARK: Private func
  
  private func configureLayers() {
    let imageViewArray = [
      (layerLevel1, "level1"),
      (layerLevel2, "level2"),
      (layerLevel3, "level3")
    ]
    imageViewArray.forEach { (layer, imgName) in
      let image = UIImage(named: imgName)?.cgImage
      layer.contents = image
      layer.contentsGravity = CALayerContentsGravity.resize
      layer.allowsEdgeAntialiasing = true
      layer.drawsAsynchronously = true
      layer.isDoubleSided = false // убирает отрисовку задней стороны слоя
      layer.backgroundColor = UIColor.clear.cgColor
      layer.frame = CGRect(
        x: 0,
        y: 0,
        width: CATransform3DViewSize,
        height: CATransform3DViewSize
      )
    }
    
    layerLevel1.zPosition = 0
    layerLevel2.zPosition = 10
    layerLevel3.zPosition = 20
    
    transformLayer.addSublayer(layerLevel1)
    transformLayer.addSublayer(layerLevel2)
    transformLayer.addSublayer(layerLevel3)
    transformLayer.frame = CGRect(
      x: 0,
      y: 0,
      width: CATransform3DViewSize,
      height: CATransform3DViewSize
    )
    
    transformLayer.transform = matrixPozitionView
  }
  
  private func refreshMatrixAndView(duration: Double) {
    var transform3D = CATransform3DIdentity
    transform3D.m34 = perspective
    
    // beginFromCurrentState and allowUserInterAction to interact with user during the animation
    // тут используем анимацию слоя тк обычная работать не будет
    let springAnimation = CASpringAnimation(keyPath: "transform")

    springAnimation.fromValue = transformLayer.transform
    springAnimation.toValue = transform3D
    springAnimation.damping = 5
    springAnimation.initialVelocity = 0.3
    springAnimation.duration = duration
    springAnimation.isCumulative = true
    springAnimation.fillMode = .forwards
    springAnimation.isRemovedOnCompletion = false
    self.transformLayer.add(springAnimation, forKey: "transform")
    
    if !CATransform3DEqualToTransform(matrixPozitionView, transform3D) {
      matrixPozitionView = transform3D
    }
  }
  
  // MARK: Constraints
  
  private func makeConstraints() {
    caTransform3DView.snp.makeConstraints { make in
      make.height.width.equalTo(CATransform3DViewSize)
      make.width.equalTo(CATransform3DViewSize)
      make.centerX.equalTo(self.snp.centerX)
      make.centerY.equalTo(self.snp.centerY)
    }
  }
  
// MARK: Setup Target
  
  private func setupGestureRecognizers() {
    panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
    
    // To avoid bugs, we set the number of touches
    
    panGestureRecognizer.maximumNumberOfTouches = 1
    caTransform3DView.addGestureRecognizer(panGestureRecognizer)
  }
}

// MARK: Pan Gesture Recognizer

extension ControlledCATransform3DViewV2 {
  @objc private func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
    guard panGestureRecognizer === gestureRecognizer else { assert(false); return }
    
    switch gestureRecognizer.state {
    case .began:
      assert(panGestureAnchorPoint == nil)
      panGestureAnchorPoint = gestureRecognizer.location(in: self)
      
    case .changed:
      guard let panGestureAnchorPoint = panGestureAnchorPoint else { assert(false); return }
      let gesturePoint = gestureRecognizer.location(in: self)
      
      // Calculate parameters for the angle in X
      
      let ratioMovementXToHalfWidthScreen = (gesturePoint.x - panGestureAnchorPoint.x) / (CATransform3DViewSize / 2)
      let angleX: Float = ( .pi / 4 ) * Float(ratioMovementXToHalfWidthScreen)
      let rotation3dX = CATransform3DRotate(matrixPozitionView, CGFloat(angleX) , 0, 1, 0)
      
      // Calculate parameters for the angle in Y
      
      let ratioMovementYToHalfWidthScreen = (gesturePoint.y - panGestureAnchorPoint.y) / (CATransform3DViewSize / 2)
      let angleY: Float = ( -.pi / 4 ) * Float(ratioMovementYToHalfWidthScreen)
      let rotation3dY = CATransform3DRotate(matrixPozitionView, CGFloat(angleY) , 1, 0, 0)

      // Transformation Concatenation operation
      
      //caTransform3DView.transform3D = CATransform3DConcat(rotation3dX, rotation3dY)
      transformLayer.transform = CATransform3DConcat(rotation3dX, rotation3dY)
      
    case .cancelled, .ended:
      refreshMatrixAndView(duration: 1.5)
      panGestureAnchorPoint = nil
      
    case .failed, .possible:
      assert(panGestureAnchorPoint == nil)
      break
      
    @unknown default:
      break
    }
  }
}
