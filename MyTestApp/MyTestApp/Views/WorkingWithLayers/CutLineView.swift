//
//  CutLineView.swift
//  MyTestApp
//
//  Created by  user on 04.05.2023.
//
import UIKit

class CutLineView: UIView {
  private let frontLayer = CAShapeLayer()
      
  // MARK: Override
      
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
    
    frontLayer.frame = bounds
    
    let maskAndShadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10)
    
    let curvePath = UIBezierPath()
    curvePath.move(to: CGPoint(x: bounds.width / 4, y: bounds.height / 4))
    curvePath.addQuadCurve(to: CGPoint(x: bounds.width * 3 / 4, y: bounds.height * 3 / 4),
                           controlPoint: CGPoint(x: bounds.width, y: 0))
    
    let innerPath =  UIBezierPath(cgPath: curvePath.cgPath.copy(strokingWithWidth: 40,
                                                                lineCap: .round,
                                                                lineJoin: .round,
                                                                miterLimit: 0))
    maskAndShadowPath.append(innerPath)
    
    (frontLayer.mask as? CAShapeLayer)?.frame = bounds
    (frontLayer.mask as? CAShapeLayer)?.path = maskAndShadowPath.cgPath
    //layer.shadowPath = maskAndShadowPath.cgPath
  }
      
  // MARK: Setup
      
  private func setup() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .clear
    frontLayer.backgroundColor = UIColor.white.cgColor
    
    layer.addSublayer(frontLayer)
    let mask = CAShapeLayer()
    mask.fillRule = .evenOdd
    frontLayer.mask = mask
    
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = .zero
    layer.shadowRadius = 10
    layer.shadowOpacity = 1
  }
}
