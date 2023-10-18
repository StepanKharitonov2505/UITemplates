//
//  ZPozitionAnimateViewController.swift
//  MyTestApp
//
//  Created by  user on 16.05.2023.
//

import UIKit

class ControlledCATransform3DViewController: UIViewController {

  var customView = ControlledCATransform3DView()
  
  override func loadView() {
    self.view = customView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}
