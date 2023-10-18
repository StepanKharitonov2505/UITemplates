//
//  AnimateButtonViewController.swift
//  MyTestApp
//
//  Created by  user on 25.05.2023.
//

import UIKit

class AnimateButtonViewController: UIViewController {

  var customView = AnimateButtonView()
  
  override func loadView() {
    self.view = customView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    customView.addGradientToButton()
    customView.repeatAnimateGradientLocation()
  }

}
