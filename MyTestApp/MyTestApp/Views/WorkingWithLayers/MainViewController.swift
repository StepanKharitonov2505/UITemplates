//
//  ViewController.swift
//  MyTestApp
//
//  Created by  user on 04.05.2023.
//

import UIKit

class MainViewController: UIViewController {

  var customView = MainView()
    
  override func loadView() {
    self.view = customView
  }
    
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

