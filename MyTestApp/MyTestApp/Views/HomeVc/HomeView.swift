//
//  HomeView.swift
//  MyTestApp
//
//  Created by  user on 10.05.2023.
//
import UIKit
import SnapKit

final class HomeView: UIView {

  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .grouped)
    tableView.backgroundColor = .clear
    tableView.separatorStyle = .none
    return tableView
  }()

  override init(frame: CGRect) {
      super.init(frame: frame)
      self.configureUI()
  }
  
  required init?(coder: NSCoder) {
      super.init(coder: coder)
      configureUI()
  }
  
  private func configureUI() {
    self.backgroundColor = SingletonColorManager.shared.colorScheme.darkMainColor
    self.addSubview(tableView)
    makeConstraints()
  }
  
  private func makeConstraints() {
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
