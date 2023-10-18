//
//  SingletonApplicationSettings.swift
//  MyTestApp
//
//  Created by  user on 12.05.2023.
//
import Foundation

class SingletonColorManager {
  
  static let shared = SingletonColorManager()
  
  private let colorSchemeCaretaker = ColorSchemeCaretaker()
  private let colorSchemes: [ColorSchemeId: ColorType] = ColorScheme().arrayColorSchemes
  var colorScheme: ColorType
  
  private init() {
    let colorId = ColorSchemeId(rawValue: colorSchemeCaretaker.retrieveColorScheme())!
    self.colorScheme = colorSchemes[colorId]!
  }
  
}
