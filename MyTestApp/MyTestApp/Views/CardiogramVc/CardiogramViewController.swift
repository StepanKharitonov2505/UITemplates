//
//  AnimateChartViewController.swift
//  MyTestApp
//
//  Created by  user on 15.05.2023.
//

import UIKit

class AnimateChartViewController: UIViewController {
  
  var customView = CardiogramView()
  
  override func loadView() {
    self.view = customView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

}
