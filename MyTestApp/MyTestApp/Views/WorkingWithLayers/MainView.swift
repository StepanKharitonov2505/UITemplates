//
//  MainView.swift
//  MyTestApp
//
//  Created by  user on 04.05.2023.
//

import Foundation
import UIKit

final class MainView: UIView {

  var croppedView = CroppedView()
  var cutLineView = CutLineView()
  var diamondsCardView = DiamondsCardView()
  var zPozitionView = ZpozitionView()
  var mountainsImageView = UIImageView()
  var labelUnderCutCurve = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
  }

  override func layoutSubviews() {
    NSLayoutConstraint.activate([
      croppedView.widthAnchor.constraint(equalToConstant: self.bounds.width/2-15),
      croppedView.heightAnchor.constraint(equalToConstant: self.bounds.width/2-15),
      croppedView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
      croppedView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10)
    ])
    NSLayoutConstraint.activate([
      labelUnderCutCurve.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
      labelUnderCutCurve.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
      labelUnderCutCurve.heightAnchor.constraint(equalToConstant: self.bounds.width/2-15),
      labelUnderCutCurve.widthAnchor.constraint(equalToConstant: self.bounds.width/2-15),
    ])
    NSLayoutConstraint.activate([
      cutLineView.topAnchor.constraint(equalTo: labelUnderCutCurve.topAnchor, constant: 10),
      cutLineView.bottomAnchor.constraint(equalTo: labelUnderCutCurve.bottomAnchor, constant: -10),
      cutLineView.leftAnchor.constraint(equalTo: labelUnderCutCurve.leftAnchor, constant: 10),
      cutLineView.rightAnchor.constraint(equalTo: labelUnderCutCurve.rightAnchor, constant: -10)
    ])
    NSLayoutConstraint.activate([
      diamondsCardView.topAnchor.constraint(equalTo: croppedView.bottomAnchor, constant: 25),
      diamondsCardView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
      diamondsCardView.widthAnchor.constraint(equalToConstant: self.bounds.width/2-15),
      diamondsCardView.heightAnchor.constraint(equalToConstant: self.bounds.width/2-15)
    ])
    NSLayoutConstraint.activate([
      mountainsImageView.topAnchor.constraint(equalTo: croppedView.bottomAnchor, constant: 25),
      mountainsImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
      mountainsImageView.widthAnchor.constraint(equalToConstant: self.bounds.width/2-15),
      mountainsImageView.heightAnchor.constraint(equalToConstant: self.bounds.width/2-15)
    ])
    NSLayoutConstraint.activate([
      zPozitionView.topAnchor.constraint(equalTo: mountainsImageView.topAnchor),
      zPozitionView.rightAnchor.constraint(equalTo: mountainsImageView.rightAnchor),
      zPozitionView.leftAnchor.constraint(equalTo: mountainsImageView.leftAnchor),
      zPozitionView.bottomAnchor.constraint(equalTo: mountainsImageView.bottomAnchor)
    ])
  }

  private func configureUI() {
    self.backgroundColor = .green
    self.addSubview(croppedView)
    self.addSubview(labelUnderCutCurve)
    self.addSubview(diamondsCardView)
    self.addSubview(mountainsImageView)
    mountainsImageView.addSubview(zPozitionView)
    labelUnderCutCurve.addSubview(cutLineView)
    customizeLabelUnderCutCurve()
    customizeMountainsImageView()
  }

  private func customizeLabelUnderCutCurve() {
    labelUnderCutCurve.translatesAutoresizingMaskIntoConstraints = false
    labelUnderCutCurve.text = "Должен ли разработчик знать всякую дичь про UI по типу вот этой? Или лучше попросить дизайнеров сделать попроще и побыстрее?"
    labelUnderCutCurve.textColor = UIColor.black
    labelUnderCutCurve.textAlignment = .center
    labelUnderCutCurve.numberOfLines = 0
    labelUnderCutCurve.lineBreakStrategy = .pushOut
  }

  private func customizeMountainsImageView() {
    mountainsImageView.translatesAutoresizingMaskIntoConstraints = false
    mountainsImageView.image = UIImage(named: "Mountains")
    mountainsImageView.contentMode = .scaleToFill
  }
}
