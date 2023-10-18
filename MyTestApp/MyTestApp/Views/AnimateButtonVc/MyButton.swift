//
//  MyButton.swift
//  MyTestApp
//
//  Created by  user on 25.05.2023.
//

import UIKit

class MyButton: UIButton {

  override var isHighlighted: Bool {
    didSet {
      if isHighlighted {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.allowUserInteraction,.beginFromCurrentState]) {
          self.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
          self.alpha = 0.75
        }
      } else {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.allowUserInteraction,.beginFromCurrentState]) {
          self.transform = CGAffineTransform(scaleX: 1, y: 1)
          self.alpha = 1
        }
      }
    }
  }
    
    override var isEnabled: Bool {
        didSet {
            
        }
    }
  

}
