//
//  HomeVc.swift
//  MyTestApp
//
//  Created by  user on 10.05.2023.
//

import UIKit

struct Cells {
  let name: String
  let description: String
}

class HomeViewController: UIViewController {
  
  var customView = HomeView()
  
  let array: [Cells] = [Cells(name: "Name 1", description: "Full description for name 1"),
                        Cells(name: "Name 2", description: "Full description for name 2"),
                        Cells(name: "Name 3", description: "Full description for name 3")]
  
  override func loadView() {
    self.view = customView
  }
  
  override func viewDidLoad() {
    setupTableView()
  }
  
  private func setupTableView() {
    customView.tableView.dataSource = self
    customView.tableView.delegate = self
    customView.tableView.register(HomeViewCell.self, forCellReuseIdentifier: "reuseIdHomeViewCell")
  }
  
}

extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return array.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdHomeViewCell", for: indexPath) as? HomeViewCell else {
      return UITableViewCell()
    }
    let item = array[indexPath.row]
    cell.config(name: item.name, detail: item.description)
    return cell
  }
}

extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let minHeight: CGFloat = 50
    let currentHeight: CGFloat = self.view.bounds.height * 1 / 11
    let height = minHeight > currentHeight ? minHeight : currentHeight
    return height
  }
}
