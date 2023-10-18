//
//  ControlledCATransform3DViewControllerV2.swift
//  MyTestApp
//
//  Created by  user on 09.09.2023.
//

import UIKit

class ControlledCATransform3DViewControllerV2: UIViewController {

  var customView = ControlledCATransform3DViewV2()
  
  override func loadView() {
    self.view = customView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}
