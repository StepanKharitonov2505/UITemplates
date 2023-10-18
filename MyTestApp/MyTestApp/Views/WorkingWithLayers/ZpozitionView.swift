//
//  ZpozitionView.swift
//  MyTestApp
//
//  Created by  user on 04.05.2023.
//
import UIKit

class ZpozitionView: UIView {
    
  private let frontLayer = CALayer()
  private let inset: CGFloat = 30
  var angleOfRotation: CGFloat = .pi / 4
  
  // MARK: Override
  
  override init(frame: CGRect) {
      super.init(frame: frame)
      setup()
  }
  
  required init?(coder: NSCoder) {
      super.init(coder: coder)
      setup()
  }
  
  override func draw(_ rect: CGRect) {
    frontLayer.frame = bounds

    // Основной слой
    let maskAndShadowPath = UIBezierPath()
    maskAndShadowPath.move(to: CGPoint(x: 0, y: inset))
    maskAndShadowPath.addLine(to: CGPoint(x: inset, y: 0))
    maskAndShadowPath.addLine(to: CGPoint(x: bounds.width - inset, y: 0))
    maskAndShadowPath.addArc(withCenter: CGPoint(x: bounds.width - inset, y: inset),
                         radius: inset,
                         startAngle: -CGFloat.pi / 2,
                         endAngle: 0,
                         clockwise: true)
    maskAndShadowPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height - inset))
    maskAndShadowPath.addLine(to: CGPoint(x: bounds.width - inset, y: bounds.height))
    maskAndShadowPath.addLine(to: CGPoint(x: inset, y: bounds.height))
    maskAndShadowPath.addArc(withCenter: CGPoint(x: inset, y: bounds.height - inset),
                         radius: inset,
                         startAngle: CGFloat.pi / 2,
                         endAngle: CGFloat.pi,
                         clockwise: true)
    maskAndShadowPath.close()

    // Вырезаем в основном слое кривую
    let curvePath = UIBezierPath()
    curvePath.move(to: CGPoint(x: bounds.width / 4, y: bounds.height / 4))
    curvePath.addQuadCurve(to: CGPoint(x: bounds.width * 3 / 4, y: bounds.height * 3 / 4),
                           controlPoint: CGPoint(x: bounds.width , y: 0))

    let innerPath =  UIBezierPath(cgPath: curvePath.cgPath.copy(strokingWithWidth: 35,
                                                                lineCap: .round,
                                                                lineJoin: .round,
                                                                miterLimit: 0))

    maskAndShadowPath.append(innerPath)

    // Рисуем линию на внутреннем вырезе СТРОГО В МЕТОДЕ DRAW()
    guard let context = UIGraphicsGetCurrentContext() else { return }
    context.setStrokeColor(UIColor.blue.cgColor)
    context.addPath(innerPath.cgPath)
    context.setLineWidth(3)
    context.strokePath()

    (frontLayer.mask as? CAShapeLayer)?.frame = bounds
    (frontLayer.mask as? CAShapeLayer)?.path = maskAndShadowPath.cgPath
  }
    
  override func layoutSubviews() {
    var transform3D = CATransform3DIdentity
    transform3D.m34 = -1 / 400
    layer.sublayerTransform = transform3D
    /* CATransform3DRotate(transform3D, -.pi / 4, 0, 1, 0)
        Рассмотрим аргументы
        -.pi / 4 - определяет угол поворота ( отрицательное значение меняет угол поворота)
        0 , 1 , 0 - оси X Y Z соответственно (Z ось направлена на нас) и тут так же если поставить перед агрументом знак - , то поворот будет осуществлен в другую сторону
            Величина значения роли не играет, важно наличие значения. Рекомендуется ставить единицы. ( Огромные (112321454353) значения никак не влияют на угол поворота, а очень маленькие (0.0000000001) значения отменяют поворот )
     */
    let rotation3D = CATransform3DRotate(transform3D, angleOfRotation, 0, 1, 0)
    layer.transform = rotation3D
  }

  // MARK: Setup

  private func setup() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .clear

    frontLayer.mask = CAShapeLayer()
    frontLayer.backgroundColor = UIColor.white.cgColor
    
    layer.addSublayer(frontLayer)
  }
}
