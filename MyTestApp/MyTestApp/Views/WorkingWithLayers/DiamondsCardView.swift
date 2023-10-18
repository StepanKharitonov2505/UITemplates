//
//  DiamondsCardView.swift
//  MyTestApp
//
//  Created by  user on 04.05.2023.
//

import Foundation
import UIKit

class DiamondsCardView: UIView {
  var selfLayer: CAShapeLayer { layer as! CAShapeLayer }
  private let inset: CGFloat = 40
  private let adjustment: CGFloat = 10

  // MARK: Override

  static override var layerClass: AnyClass { CAShapeLayer.self }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    let path = UIBezierPath()
    let size = bounds.width - 2 * inset

    path.move(to: CGPoint(x: inset, y: bounds.height / 2))
    path.addQuadCurve(to: CGPoint(x: bounds.width / 2, y: bounds.height / 2 - size / 2),
                      controlPoint: CGPoint(x: bounds.width / 2 - adjustment, y: bounds.height / 2 - adjustment))
    path.addQuadCurve(to: CGPoint(x: bounds.width - inset, y: bounds.height / 2),
                      controlPoint: CGPoint(x: bounds.width / 2 + adjustment, y: bounds.height / 2 - adjustment))
    path.addQuadCurve(to: CGPoint(x: bounds.width / 2, y: bounds.height / 2 + size / 2),
                      controlPoint: CGPoint(x: bounds.width / 2 + adjustment, y: bounds.height / 2 + adjustment))
    path.addQuadCurve(to: CGPoint(x: inset, y: bounds.height / 2),
                      controlPoint: CGPoint(x: bounds.width / 2 - adjustment, y: bounds.height / 2 + adjustment))

    selfLayer.path = path.cgPath
  }

  // MARK: Setup

  private func setup() {
    translatesAutoresizingMaskIntoConstraints = false
    selfLayer.fillColor = UIColor.red.cgColor
    selfLayer.strokeColor = UIColor.red.cgColor
    selfLayer.lineWidth = 2

    backgroundColor = UIColor.white
    let cornerRect: UIRectCorner = [.topLeft, .bottomLeft] /// Выбираем какие углы хотим скруглить
    layer.maskedCorners = CACornerMask(rawValue: cornerRect.rawValue)
    layer.cornerRadius = 20
      
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = .zero
    layer.shadowRadius = 10
    layer.shadowOpacity = 1
  }
}
