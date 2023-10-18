//
//  File.swift
//  MyTestApp
//
//  Created by  user on 12.05.2023.
//

import Foundation

class ColorSchemeCaretaker {
  private let key = ConstantsStroke.keyColorScheme

  func save(colorVersion: Int) {
    if ColorSchemeId(rawValue: colorVersion) != nil {
      UserDefaults.standard.set(colorVersion, forKey: key)
    }
  }

  func retrieveColorScheme() -> Int {
    UserDefaults.standard.integer(forKey: key)
  }
}
