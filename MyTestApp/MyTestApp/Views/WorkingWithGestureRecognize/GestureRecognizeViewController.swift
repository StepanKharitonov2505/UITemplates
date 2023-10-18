//
//  GestureRecognizeViewController.swift
//  MyTestApp
//
//  Created by  user on 16.05.2023.
//

import UIKit

class GestureRecognizeViewController: UIViewController {

  var customView = GestureRecognizeView()
  
  override func loadView() {
    self.view = customView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
