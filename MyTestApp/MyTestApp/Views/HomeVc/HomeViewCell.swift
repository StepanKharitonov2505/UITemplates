//
//  HomeViewCellTableViewCell.swift
//  MyTestApp
//
//  Created by  user on 11.05.2023.
//

import UIKit
import SnapKit

class HomeViewCell: UITableViewCell {
  
  private var baseBackgroundView = UIView()
  private var stackVertical = UIStackView()
  private var cellName = UILabel()
  private var cellDetailedDescription = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func config(name: String, detail: String ) {
    cellName.text = name
    cellDetailedDescription.text = detail
  }
  
  private func configureUI() {
    self.backgroundColor = .clear
    self.addSubview(baseBackgroundView)
    stackVertical.addArrangedSubview(cellName)
    stackVertical.addArrangedSubview(cellDetailedDescription)
    baseBackgroundView.addSubview(stackVertical)
    configureBaseBackgroundView()
    configureCellName()
    configureCellDetailedDescription()
    configureStack()
    makeConstraints()
  }

// MARK: Configure subviews

  private func configureBaseBackgroundView() {
    baseBackgroundView.backgroundColor = SingletonColorManager.shared.colorScheme.extraLightMainColor
    baseBackgroundView.layer.cornerRadius = 5
  }
  
  private func configureCellName() {
    cellName.textColor = SingletonColorManager.shared.colorScheme.darkMainColor
    cellName.font = UIFont(name: "Montserrat-Bold", size: 17)
  }
  
  private func configureCellDetailedDescription() {
    cellDetailedDescription.textColor = SingletonColorManager.shared.colorScheme.lightDarkMainColor
    cellDetailedDescription.font = UIFont(name: "Montserrat-Medium", size: 15)
  }
  
  private func configureStack() {
    stackVertical.translatesAutoresizingMaskIntoConstraints = false
    stackVertical.axis = .vertical
    stackVertical.alignment = .leading
    stackVertical.distribution = .fillEqually
  }
  
// MARK: Make constraints
  
  private func makeConstraints() {
    baseBackgroundView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 2.5, left: 10, bottom: 2.5, right: 10))
    }
    
    stackVertical.snp.makeConstraints { make in
      make.height.equalTo(cellName.snp.height).multipliedBy(2)
      make.center.equalTo(baseBackgroundView.snp.center)
      make.left.equalTo(baseBackgroundView.snp.left).inset(15)
    }
  }
}


