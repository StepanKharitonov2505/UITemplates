//
//  ZPozitionView.swift
//  MyTestApp
//
//  Created by  user on 16.05.2023.
//
import UIKit
import SnapKit

class ControlledCATransform3DView: UIView {

  // MARK: Refresh Button
  
  let ssMainColor = UIColor.rgb(51, 106, 242)
  
  lazy var refreshButton: UIButton = {
    let button = UIButton(type: .system)
    button.tintColor = .white
    button.setTitle("Refresh rotation", for: .normal)
    button.backgroundColor = ssMainColor
    button.layer.cornerRadius = 10
//    button.layer.shadowColor = UIColor.black.cgColor
//    button.layer.shadowRadius = 5
//    button.layer.shadowOpacity = 0
//    button.layer.shadowOffset = .zero
    button.layer.masksToBounds = false
    button.layer.opacity = 0.5
    button.isEnabled = false
    return button
  }()
  
  // MARK: Labels
  
  var labelZ = UILabel()
  var labelX = UILabel()
  var labelY = UILabel()
  
  // MARK: CATransform3DView
  
  var CATransform3DView = UIView()
  let perspective: CGFloat = -1 / 600
  lazy var matrixPozitionView: CATransform3D = {
    var transform3D = CATransform3DIdentity
    transform3D.m34 = perspective
    CATransform3DView.layer.sublayerTransform = transform3D
    return transform3D
  }() {
    didSet {
      refreshButtonIsEnabled()
    }
  }
  
  var imageView = UIImageView()

  let CATransform3DViewSize: CGFloat = 250
  
  // MARK: Sliders
  
  var sliderZRotate = UISlider()
  var sliderYRotate = UISlider()
  var sliderXRotate = UISlider()
  
  // Constants for the axes of rotation
  let axisX: [CGFloat] = [1,0,0]
  let axisY: [CGFloat] = [0,1,0]
  let axisZ: [CGFloat] = [0,0,1]
  
  // MARK: Gesture Recognizers
  
  private let panGestureRecognizer = UIPanGestureRecognizer()
  private var panGestureAnchorPoint: CGPoint?
  
  // MARK: Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    setupTargetToSliders()
    setupTargetToRefreshButton()
    setupGestureRecognizers()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
    setupTargetToSliders()
    setupTargetToRefreshButton()
    setupGestureRecognizers()
  }
  
  // MARK: Load UI
  
  private func configureUI() {
    self.backgroundColor = SingletonColorManager.shared.colorScheme.darkMainColor
    
    self.addSubview(refreshButton)
    self.addSubview(CATransform3DView)
    CATransform3DView.addSubview(imageView)
    
    setupXYZSliders()
    
    configureZPozitionView()
    configureImageView()
    setupLabels()
    makeConstraints()
  }
  
  // MARK: Private func
  
  private func configureZPozitionView() {
    CATransform3DView.translatesAutoresizingMaskIntoConstraints = false
    CATransform3DView.backgroundColor = .clear
//    CATransform3DView.layer.borderWidth = 4
//    CATransform3DView.layer.borderColor = UIColor.white.cgColor
    CATransform3DView.clipsToBounds = true
  }
  
  private func configureImageView() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "ssLogoSymbolBlue2")
    imageView.contentMode = .scaleAspectFit
  }
  
  private func setupXYZSliders() {
    let sliders: [UISlider] = [sliderXRotate, sliderYRotate, sliderZRotate]
    sliders.forEach {
      $0.thumbTintColor = .white
      $0.minimumTrackTintColor = ssMainColor
      $0.maximumTrackTintColor = ssMainColor
      $0.minimumValue = -.pi / 4;
      $0.maximumValue = .pi / 4;
      $0.value = 0;
      self.addSubview($0)
    }
  }
  
  private func setupLabels() {
    labelX.text = "Rotation by X"
    labelY.text = "Rotation by Y"
    labelZ.text = "Rotation by Z"
    
    let labelContainer = [labelX, labelY, labelZ]
    labelContainer.forEach {
      $0.font = UIFont(name: "Montserrat-Medium", size: 15);
      $0.textColor = .white;
      self.addSubview($0)
    }
  }
  
  private func refreshButtonIsEnabled() {
    refreshButton.isEnabled = true
    UIView.animate(withDuration: 0.3) {
      self.refreshButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
      self.refreshButton.layer.opacity = 1
      //self.refreshButton.layer.shadowOpacity = 0.5
    }
  }
  
  private func refreshButtonIsDisabled() {
    refreshButton.isEnabled = false
    UIView.animate(withDuration: 0.3) {
      self.refreshButton.transform = CGAffineTransform(scaleX: 1, y: 1)
      self.refreshButton.layer.opacity = 0.5
      //self.refreshButton.layer.shadowOpacity = 0
    }
  }
  
  private func refreshMatrixAndView(duration: Double) {
    var transform3D = CATransform3DIdentity
    transform3D.m34 = perspective
//    UIView.animate(withDuration: duration, animations: {
//      self.CATransform3DView.transform3D = transform3D
//    })
    
    // beginFromCurrentState and allowUserInterAction to interact with user during the animation
    
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.35, initialSpringVelocity: 0.3, options: [.beginFromCurrentState, .allowUserInteraction]) {
      self.CATransform3DView.transform3D = transform3D
    }
    
    if !CATransform3DEqualToTransform(matrixPozitionView, transform3D) {
      matrixPozitionView = transform3D
    }
  }
  
  // MARK: Constraints
  
  private func makeConstraints() {
    CATransform3DView.snp.makeConstraints { make in
      make.height.width.equalTo(CATransform3DViewSize)
      make.centerX.equalTo(self.snp.centerX)
      make.top.equalTo(self.snp.top).offset(120)
    }
    
    imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    // rotation by Z
    
    labelZ.snp.makeConstraints { make in
      make.centerX.equalTo(self.snp.centerX)
      make.top.equalTo(CATransform3DView.snp.bottom).offset(80)
    }

    sliderZRotate.snp.makeConstraints { make in
      make.top.equalTo(labelZ.snp.bottom).offset(6)
      make.left.equalTo(self.snp.left).offset(50)
      make.right.equalTo(self.snp.right).inset(50)
    }
    
    // rotation by Y

    labelY.snp.makeConstraints { make in
      make.centerX.equalTo(self.snp.centerX)
      make.top.equalTo(sliderZRotate.snp.bottom).offset(15)
    }

    sliderYRotate.snp.makeConstraints { make in
      make.top.equalTo(labelY.snp.bottom).offset(6)
      make.left.equalTo(self.snp.left).offset(50)
      make.right.equalTo(self.snp.right).inset(50)
    }
    
    // rotation by X
    
    labelX.snp.makeConstraints { make in
      make.centerX.equalTo(self.snp.centerX)
      make.top.equalTo(sliderYRotate.snp.bottom).offset(15)
    }

    sliderXRotate.snp.makeConstraints { make in
      make.top.equalTo(labelX.snp.bottom).offset(6)
      make.left.equalTo(self.snp.left).offset(50)
      make.right.equalTo(self.snp.right).inset(50)
    }
    
    // button
    
    refreshButton.snp.makeConstraints { make in
      make.top.equalTo(sliderXRotate.snp.bottom).offset(25)
      make.centerX.equalTo(self.snp.centerX)
      make.left.equalToSuperview().offset(50)
      make.right.equalToSuperview().inset(50)
      make.height.equalTo(50)
    }
  }
  
// MARK: Setup Target
  
  private func setupTargetToSliders() {
    sliderZRotate.addTarget(self, action: #selector(handleSliderZRotate(_:)), for: .allEvents)
    sliderYRotate.addTarget(self, action: #selector(handleSliderYRotate(_:)), for: .allEvents)
    sliderXRotate.addTarget(self, action: #selector(handleSliderXRotate(_:)), for: .allEvents)
  }
  
  private func setupTargetToRefreshButton() {
    refreshButton.addTarget(self, action: #selector(handleRefreshButton(_:)), for: .touchUpInside)
  }
  
  private func setupGestureRecognizers() {
    panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
    
    // To avoid bugs, we set the number of touches
    
    panGestureRecognizer.maximumNumberOfTouches = 1
    
    CATransform3DView.addGestureRecognizer(panGestureRecognizer)
  }
}

// MARK: Change Rotate methods

extension ControlledCATransform3DView {
  private func changeRotate(_ slider: UISlider, axis: [CGFloat]) {
    let rotation3D = CATransform3DRotate(matrixPozitionView, CGFloat(slider.value), axis[0], axis[1], axis[2])
    CATransform3DView.transform3D = rotation3D
  }
}

// MARK: Actions

extension ControlledCATransform3DView {
  @objc private func handleSliderZRotate(_ slider: UISlider) {
    switch slider.state {
    case .normal:
      
      // We save the slider values at the end of the interaction
      
      let max = slider.maximumValue
      let min = slider.minimumValue
      let value = slider.value
      
      // Next updating slider values
      // Since the matrix is already rotated by a certain angle
      // Set the current value to zero to avoid automatic triggering of the transformation (transformation by angle slider.value) during subsequent interactions with the slider
      
      slider.maximumValue = max - value
      slider.minimumValue = min - value
      slider.value = 0
      
      // Save transform matrix
      // Next transformations will be applied to the saved matrix
      
      matrixPozitionView = CATransform3DView.transform3D
    case .highlighted:
      changeRotate(sliderZRotate, axis: axisZ)
    default:
      print("default")
    }
  }
  
  @objc private func handleSliderYRotate(_ slider: UISlider) {
    switch slider.state {
    case .normal:
      let max = slider.maximumValue
      let min = slider.minimumValue
      let value = slider.value
      slider.maximumValue = max - value
      slider.minimumValue = min - value
      slider.value = 0
      matrixPozitionView = CATransform3DView.transform3D
    case .highlighted:
      changeRotate(sliderYRotate, axis: axisY)
    default:
      print("default")
    }
  }
  
  @objc private func handleSliderXRotate(_ slider: UISlider) {
    switch slider.state {
    case .normal:
      let max = slider.maximumValue
      let min = slider.minimumValue
      let value = slider.value
      slider.maximumValue = max - value
      slider.minimumValue = min - value
      slider.value = 0
      matrixPozitionView = CATransform3DView.transform3D
    case .highlighted:
      changeRotate(sliderXRotate, axis: axisX)
    default:
      print("default")
    }
  }
  
  @objc private func handleRefreshButton(_ button: UIButton) {
    let sliders = [sliderXRotate, sliderYRotate, sliderZRotate]
    sliders.forEach {
      $0.minimumValue = -.pi / 4;
      $0.maximumValue = .pi / 4;
      $0.value = 0
    }
    refreshMatrixAndView(duration: 1)
    let tapGenerator = UIImpactFeedbackGenerator(style: .medium)
    tapGenerator.impactOccurred()
    refreshButtonIsDisabled()
  }
}

// MARK: Pan Gesture Recognizer

extension ControlledCATransform3DView {
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
      
      CATransform3DView.transform3D = CATransform3DConcat(rotation3dX, rotation3dY)

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
