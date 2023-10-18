//
//  GestureRecognizeView.swift
//  MyTestApp
//
//  Created by  user on 16.05.2023.
//

import UIKit

class GestureRecognizeView: UIView {
  
  let nameScreen = UILabel()
  let descriptionScreen = UILabel()

  // MARK: Box properties
  
  var boxView = UIView()
  
  private var widthConstraint: NSLayoutConstraint!
  private var heightConstraint: NSLayoutConstraint!
  private var centerYConstraint: NSLayoutConstraint!
  private var centerXConstraint: NSLayoutConstraint!
  
  private let initialBoxSize: CGFloat = 150
  private let boxCornerRadius: CGFloat = 10
  private let boxPossibleColors: [UIColor] = [.red, .yellow, .blue]
  
  private var colorIndex = 0
  
  private var scale: CGFloat = 1.0 { didSet { updateBoxTransform() } }
  private var rotation: CGFloat = 0.0 { didSet { updateBoxTransform() } }
  
  // MARK: Gesture recognizers
  
  private let panGestureRecognizer = UIPanGestureRecognizer()
  private let pinchGestureRecognizer = UIPinchGestureRecognizer()
  private let rotateGestureRecognizer = UIRotationGestureRecognizer()
  private let singleTapGestureRecognizer = UITapGestureRecognizer()
  private let doubleTapGestureRecognizer = UITapGestureRecognizer()
  
  private var panGestureAnchorPoint: CGPoint?
  private var pinchGestureAnchorScale: CGFloat?
  private var rotateGestureAnchorRotation: CGFloat?

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
    self.addSubview(boxView)
    self.insertSubview(nameScreen, at: 0)
    self.insertSubview(descriptionScreen, at: 0)
    configureBoxView()
    configureNameScreen()
    configureDescriptionScreen()
  }
  
  // MARK: Private func
  
  private func configureBoxView() {
    boxView.translatesAutoresizingMaskIntoConstraints = false
    boxView.backgroundColor = boxPossibleColors[colorIndex]
    boxView.layer.cornerRadius = boxCornerRadius
    boxView.clipsToBounds = true
    
    widthConstraint = boxView.widthAnchor.constraint(equalToConstant: initialBoxSize)
    heightConstraint = boxView.heightAnchor.constraint(equalToConstant: initialBoxSize)
    centerYConstraint = boxView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    centerXConstraint = boxView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    
    NSLayoutConstraint.activate([widthConstraint,
                                heightConstraint,
                                centerXConstraint,
                                centerYConstraint])
  }
  
  private func configureNameScreen() {
    nameScreen.translatesAutoresizingMaskIntoConstraints = false
    nameScreen.text = "Gesture Recognizers"
    nameScreen.font = UIFont(name: "Montserrat-ExtraBold", size: 35)
    nameScreen.textAlignment = .left
    nameScreen.textColor = .white
    nameScreen.numberOfLines = 0
    
    
    NSLayoutConstraint.activate([
      nameScreen.topAnchor.constraint(equalTo: self.topAnchor,constant: 50),
      nameScreen.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
      nameScreen.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)])
  }
  
  private func configureDescriptionScreen() {
    descriptionScreen.translatesAutoresizingMaskIntoConstraints = false
    descriptionScreen.text = """
    - Коснитесь пальцем, чтобы переместить
    
    - Щипок двумя пальцами, чтобы увеличить
    
    - Вращайте двумя пальцами
    
    - Одно нажатие, чтобы изменить цвет
    
    - Два нажатия, чтобы вернуть в дефолтное положение.
    """
    descriptionScreen.font = UIFont(name: "Montserrat-Medium", size: 15)
    descriptionScreen.textAlignment = .left
    descriptionScreen.textColor = .white
    descriptionScreen.numberOfLines = 0
    
    
    NSLayoutConstraint.activate([
      descriptionScreen.topAnchor.constraint(equalTo: self.nameScreen.bottomAnchor,constant: 15),
      descriptionScreen.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
      descriptionScreen.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)])
  }

  private func setupGestureRecognizers() {
    panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
    // Выставляем количество касаний для избежания багов
    panGestureRecognizer.maximumNumberOfTouches = 1
    
    pinchGestureRecognizer.addTarget(self, action: #selector(handlePinchGesture(_:)))
    rotateGestureRecognizer.addTarget(self, action: #selector(handleRotateGesture(_:)))
    
    singleTapGestureRecognizer.addTarget(self, action: #selector(handleSingleTapGesture(_:)))
    singleTapGestureRecognizer.numberOfTapsRequired = 1
    
    doubleTapGestureRecognizer.addTarget(self, action: #selector(handleDoubleTapGesture(_:)))
    doubleTapGestureRecognizer.numberOfTapsRequired = 2
    
    let gesture = [panGestureRecognizer,
                   pinchGestureRecognizer,
                   rotateGestureRecognizer,
                   singleTapGestureRecognizer,
                   doubleTapGestureRecognizer]
    
    // Присваиваем делегатов
    gesture.forEach { $0.delegate = self }
    // Добавляем рекогнизеры на коробочку
    gesture.forEach { boxView.addGestureRecognizer($0)}
  }
}

// MARK: Func update box transform

extension GestureRecognizeView {
  private func updateBoxTransform() {
    boxView.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale).rotated(by: rotation)
  }
}

// MARK: GestureRecognizer Delegate
// Необходим для совместной работы разных рекогнизеров

extension GestureRecognizeView: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    let simultaneousRecognizers = [panGestureRecognizer, pinchGestureRecognizer, rotateGestureRecognizer]
    return simultaneousRecognizers.contains(gestureRecognizer) && simultaneousRecognizers.contains(otherGestureRecognizer)
  }

  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return gestureRecognizer === singleTapGestureRecognizer && otherGestureRecognizer === doubleTapGestureRecognizer
  }
}

// MARK: Pan recognizer

extension GestureRecognizeView {
  @objc private func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
    guard panGestureRecognizer === gestureRecognizer else { assert(false); return }
    
    switch gestureRecognizer.state {
    case .began:
      assert(panGestureAnchorPoint == nil)
      panGestureAnchorPoint = gestureRecognizer.location(in: self)
      
    case .changed:
      guard let panGestureAnchorPoint = panGestureAnchorPoint else { assert(false); return }
      let gesturePoint = gestureRecognizer.location(in: self)
      
      centerXConstraint.constant += gesturePoint.x - panGestureAnchorPoint.x
      centerYConstraint.constant += gesturePoint.y - panGestureAnchorPoint.y
      self.panGestureAnchorPoint = gesturePoint
      
    case .cancelled, .ended:
      panGestureAnchorPoint = nil
      
    case .failed, .possible:
      assert(panGestureAnchorPoint == nil)
      break
      
    @unknown default:
      break
    }
  }
}

// MARK: Pinch recognizer

extension GestureRecognizeView {
  @objc private func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
    guard pinchGestureRecognizer === gestureRecognizer else { assert(false); return }

    switch gestureRecognizer.state {
    case .began:
      assert(pinchGestureAnchorScale == nil)
      pinchGestureAnchorScale = gestureRecognizer.scale

    case .changed:
      guard let pinchGestureAnchorScale = pinchGestureAnchorScale else {
        assert(false); return
      }

      let gestureScale = gestureRecognizer.scale
      scale += gestureScale - pinchGestureAnchorScale
      self.pinchGestureAnchorScale = gestureScale

    case .cancelled, .ended:
      pinchGestureAnchorScale = nil

    case .failed, .possible:
      assert(pinchGestureAnchorScale == nil)
      break
      
    @unknown default:
      break
    }
  }
}

// MARK: Rotate recogniaer

extension GestureRecognizeView {
  @objc private func handleRotateGesture(_ gestureRecognizer: UIRotationGestureRecognizer) {
    guard rotateGestureRecognizer === gestureRecognizer else { assert(false); return }

    switch gestureRecognizer.state {
    case .began:
      assert(rotateGestureAnchorRotation == nil)
      rotateGestureAnchorRotation = gestureRecognizer.rotation

    case .changed:
      guard let rotateGestureAnchorRotation = rotateGestureAnchorRotation else {
        assert(false); return
      }

      let gestureRotation = gestureRecognizer.rotation
      rotation += gestureRotation - rotateGestureAnchorRotation
      self.rotateGestureAnchorRotation = gestureRotation

    case .cancelled, .ended:
      rotateGestureAnchorRotation = nil

    case .failed, .possible:
      assert(rotateGestureAnchorRotation == nil)
      break
      
    @unknown default:
      break
    }
  }
}

// MARK: SingleTap recognizer

extension GestureRecognizeView {
  @objc private func handleSingleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
    colorIndex = (colorIndex + 1) % boxPossibleColors.count
    UIView.transition(with: boxView, duration: 0.3, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
      self.boxView.backgroundColor = self.boxPossibleColors[self.colorIndex]
    })
  }
}

// MARK: DoubleTap recognizer

extension GestureRecognizeView {
  @objc private func handleDoubleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
          widthConstraint.constant = initialBoxSize
          heightConstraint.constant = initialBoxSize
          centerXConstraint.constant = 0.0
          centerYConstraint.constant = 0.0

          UIView.animate(
              withDuration: 0.3,
              delay: 0.0,
              options: [.curveEaseInOut],
              animations: {
                  self.scale = 1.0
                  self.rotation = 0.0
                  self.layoutIfNeeded()
              },
              completion: nil
          )
      }
}
