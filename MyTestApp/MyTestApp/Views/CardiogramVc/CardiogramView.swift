//
//  AnimateChartView.swift
//  MyTestApp
//
//  Created by  user on 15.05.2023.
//

import UIKit
import SnapKit

class CardiogramView: UIView {
  
  let layerAnimateCardiogram: CAShapeLayer = {
    let subLayer = CAShapeLayer()
    subLayer.strokeColor = UIColor.yellow.cgColor
    subLayer.lineWidth = 2
    subLayer.fillColor = UIColor.clear.cgColor
    return subLayer
  }()
  
  var chartView = UIView()

  override init(frame: CGRect) {
      super.init(frame: frame)
      self.configureUI()
  }
  
  required init?(coder: NSCoder) {
      super.init(coder: coder)
      configureUI()
  }
  
  override func draw(_ rect: CGRect) {
    let startPath = createCardiogramSnapshot(parentView: chartView)
    layerAnimateCardiogram.path = startPath.cgPath

    let animationGroup = createGroupAnimationCardiogram()
    layerAnimateCardiogram.add(animationGroup, forKey: nil)
    
    chartView.layer.addSublayer(layerAnimateCardiogram)
  }
  
  private func configureUI() {
    self.backgroundColor = SingletonColorManager.shared.colorScheme.darkMainColor
    self.addSubview(chartView)
    configureChartView()
    makeConstraints()
  }
  
  private func configureChartView() {
    chartView.translatesAutoresizingMaskIntoConstraints = false
    chartView.layer.borderWidth = 4
    chartView.layer.borderColor = UIColor.lightGray.cgColor
    chartView.layer.cornerRadius = 15
    

//    chartView.layer.shadowColor = UIColor.white.cgColor
//    chartView.layer.shadowRadius = 10
//    chartView.layer.shadowOpacity = 0.2
    chartView.layer.masksToBounds = false
    chartView.clipsToBounds = false
    
    chartView.backgroundColor = .black
  }
  
  private func makeConstraints() {
    chartView.snp.makeConstraints { make in
      make.height.equalTo(self.snp.height).multipliedBy(0.2)
      make.width.equalTo(self.snp.width).multipliedBy(0.75)
      make.centerX.equalTo(self.snp.centerX)
      make.top.equalTo(self.snp.top).offset(50)
    }
  }
}

// MARK: Create Cardiogram line
extension CardiogramView {
  private func createCardiogramSnapshot(parentView: UIView, coefLineHeight: CGFloat = 1) -> UIBezierPath  {
    let lineWidth: CGFloat = parentView.bounds.width
    let lineHeight: CGFloat = parentView.bounds.height * 0.35 * coefLineHeight
    let startPoint = CGPoint(x: parentView.bounds.minX, y: parentView.bounds.midY)
    let endPoint = CGPoint(x: startPoint.x + lineWidth, y: startPoint.y)
    let stepByX = endPoint.x/8
    
    let path = UIBezierPath()
    path.move(to: startPoint)
    path.addLine(to: CGPoint(x: startPoint.x + stepByX, y: startPoint.y))
    path.addLine(to: CGPoint(x: startPoint.x + 1.5 * stepByX, y: startPoint.y - lineHeight))
    path.addLine(to: CGPoint(x: startPoint.x + 2 * stepByX, y: startPoint.y + lineHeight))
    path.addLine(to: CGPoint(x: startPoint.x + 2.5 * stepByX, y: startPoint.y - 0.5 * lineHeight))
    path.addLine(to: CGPoint(x: startPoint.x + 2.75 * stepByX, y: startPoint.y + 0.2 * lineHeight))
    path.addLine(to: CGPoint(x: startPoint.x + 3 * stepByX, y: startPoint.y))
    path.addLine(to: CGPoint(x: startPoint.x + 5.5 * stepByX, y: startPoint.y))
    path.addLine(to: CGPoint(x: startPoint.x + 5.6 * stepByX, y: startPoint.y - 0.1 * lineHeight))
    path.addLine(to: CGPoint(x: startPoint.x + 5.7 * stepByX, y: startPoint.y + 0.1 * lineHeight))
    path.addLine(to: CGPoint(x: startPoint.x + 5.8 * stepByX, y: startPoint.y))
    path.addLine(to: endPoint)
        
    return path
  }
}

// MARK: Create animate Cardiogram
extension CardiogramView {
  private func createAnimateStrokeEndCardiogram() -> CABasicAnimation {
    let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
    pathAnimation.fromValue = 0
    pathAnimation.toValue = 1.3

    return pathAnimation
  }
  
  private func createAnimateStrokeStartCardiogram() -> CABasicAnimation {
    let pathAnimation = CABasicAnimation(keyPath: "strokeStart")
    pathAnimation.fromValue = -1
    pathAnimation.toValue = 1
    
    return pathAnimation
  }
  
  private func createAnimateOpacityCardiogram() -> CABasicAnimation {
    let pathAnimation = CABasicAnimation(keyPath: "opacity")
    pathAnimation.fromValue = 1
    pathAnimation.toValue = 0.1
    pathAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
    
    return pathAnimation
  }
  
  private func createGroupAnimationCardiogram() -> CAAnimationGroup {
    let animationGroup = CAAnimationGroup()
    animationGroup.duration = 2
    animationGroup.repeatCount = .greatestFiniteMagnitude
    animationGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
    animationGroup.animations = [createAnimateStrokeStartCardiogram(),
                                 createAnimateStrokeEndCardiogram(),
                                 createAnimateOpacityCardiogram()]
    
    return animationGroup
  }
}
