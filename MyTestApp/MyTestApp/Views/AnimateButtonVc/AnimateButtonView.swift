//
//  AnimateButtonView.swift
//  MyTestApp
//
//  Created by  user on 25.05.2023.
//
import UIKit

// As in the Telegram

class AnimateButtonView: UIView {

  let ssMainColor = UIColor.rgb(51, 106, 242)
  
  lazy var myButton: MyButton = {
    let button = MyButton()
    button.tintColor = .white
    button.setTitle("Click me and be happy!", for: .normal)
    button.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 17)
    button.titleLabel?.adjustsFontSizeToFitWidth = true
    button.backgroundColor = ssMainColor
    button.layer.cornerRadius = 10
    button.layer.masksToBounds = true
    return button
  }()
  
  lazy var gradientLayer = CAGradientLayer()
  var timer = Timer()
  let fromLocationGradient: [NSNumber] = [-1.0, -0.5, 0.0]
  let toLocationGradient: [NSNumber] = [1.0, 1.5, 2.0]
  
  // MARK: Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    setupTargetToButton()
    animateResizeTextButton()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
    setupTargetToButton()
    animateResizeTextButton()
  }
  
  // MARK: Load UI
  
  private func configureUI() {
    self.backgroundColor = SingletonColorManager.shared.colorScheme.darkMainColor
    self.addSubview(myButton)
    makeConstraints()
  }
  
  private func makeConstraints() {
    myButton.snp.makeConstraints { make in
      make.centerX.equalTo(self.snp.centerX)
      make.centerY.equalTo(self.snp.centerY)
      make.height.equalTo(50)
      make.left.equalTo(self.snp.left).offset(30)
      make.right.equalTo(self.snp.right).inset(30)
    }
  }
  
  // MARK: Setup target
  
  private func setupTargetToButton() {
    myButton.addTarget(self, action: #selector(handleTelegramButton(_:)), for: .allEvents)
  }
}

  // MARK: Animate resize text button

extension AnimateButtonView {
  private func animateResizeTextButton() {
    UIView.animate(withDuration: 2,
                   delay: 0,
                   options: [.repeat, .autoreverse]) {
      self.myButton.titleLabel?.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
    }
  }
}

  // MARK: Animate button layer gradient

extension AnimateButtonView {
  func addGradientToButton() {
    let centerWhiteColor = UIColor.white.withAlphaComponent(0.5)
    gradientLayer.frame = myButton.bounds
    gradientLayer.colors = [ ssMainColor.cgColor, centerWhiteColor.cgColor, ssMainColor.cgColor]
    gradientLayer.locations = fromLocationGradient
    gradientLayer.startPoint = CGPoint.init(x: 0, y: 0.01)
    gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
    myButton.layer.insertSublayer(gradientLayer, below: myButton.titleLabel?.layer)
  }
  
  private func animateGradientLocation() {
    let animation: CABasicAnimation = CABasicAnimation(keyPath: "locations")
    animation.fromValue = fromLocationGradient
    animation.toValue = toLocationGradient
    animation.duration = 0.6
    animation.fillMode = CAMediaTimingFillMode.forwards
    animation.timingFunction = CAMediaTimingFunction(name: .linear)
    animation.isRemovedOnCompletion = true
    gradientLayer.add(animation, forKey: "locations")
  }
  
  func repeatAnimateGradientLocation() {
    timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
      self.animateGradientLocation()
    }
  }
}

  // MARK: Action button

extension AnimateButtonView {
  @objc private func handleTelegramButton(_ button: UIButton) {
    print("pressed button")
  }
}
