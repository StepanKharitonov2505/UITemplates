//
//  GradientMaskView.swift
//  MyTestApp
//
//  Created by  user on 09.10.2023.
//

import UIKit

class GradientMaskView: UIView {
    
    private lazy var gradientLayer = makeGradientLayer()
    private lazy var textAttributes: [NSAttributedString.Key: Any] = {
      let style = NSMutableParagraphStyle()
      style.alignment = .center
      return [
        .font: UIFont.systemFont(
          ofSize: 24,
          weight: .bold),
        .paragraphStyle: style
      ]
    }()
    private var text: String = "ГРАДИЕНТ ЗАЧЕТ, БРАТ"

    override func layoutSubviews() {
        gradientLayer.frame = CGRect(
            x: -bounds.size.width,
            y: bounds.origin.y,
            width: 3 * bounds.size.width,
            height: bounds.size.height
        )
        configureUI()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        layer.addSublayer(gradientLayer)
        animateGradientLayer()
    }
}

private extension GradientMaskView {
    func configureUI() {
        let image = UIGraphicsImageRenderer(size: bounds.size)
        .image { _ in
          text.draw(in: bounds, withAttributes: textAttributes)
        }

        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.clear.cgColor
        maskLayer.frame = bounds.offsetBy(dx: bounds.size.width, dy: 0)
        maskLayer.contents = image.cgImage

        gradientLayer.mask = maskLayer
    }
    
    func animateGradientLayer() {
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
//        gradientAnimation.fromValue = [0.0, 0.0, 0.25]
//        gradientAnimation.toValue = [0.75, 1.0, 1.0]
        gradientAnimation.fromValue = [0.0, 0.0, 0.0, 0.0, 0.0, 0.25]
        gradientAnimation.toValue = [0.65, 0.8, 0.85, 0.9, 0.95, 1.0]
        gradientAnimation.duration = 3.0
        gradientAnimation.repeatCount = Float.infinity
        gradientLayer.add(gradientAnimation, forKey: nil)
    }
    
    func makeGradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
//        let colors = [
//          UIColor.black.cgColor,
//          UIColor.white.cgColor,
//          UIColor.black.cgColor
//        ]
//        let locations: [NSNumber] = [
//          0.25,
//          0.5,
//          0.75
//        ]
        let colors = [
            UIColor.yellow.cgColor,
            UIColor.green.cgColor,
            UIColor.orange.cgColor,
            UIColor.cyan.cgColor,
            UIColor.red.cgColor,
            UIColor.yellow.cgColor
        ]
        gradientLayer.colors = colors
        
        let locations: [NSNumber] = [
            0.25,
            0.35,
            0.45,
            0.55,
            0.65,
            0.75
        ]
        gradientLayer.locations = locations
        return gradientLayer
    }
}
