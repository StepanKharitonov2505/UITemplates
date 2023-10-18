//
//  File.swift
//  MyTestApp
//
//  Created by  user on 12.05.2023.
//
import UIKit

struct ColorType {
  let mainColor: UIColor
  let darkMainColor: UIColor
  let lightDarkMainColor: UIColor
  let lightMainColor: UIColor
  let extraLightMainColor: UIColor
}

/// Color scheme V1.0
/// Link to the color scheme https://colorscheme.ru/#3r11Tw0w0w0w0
/// Color scheme V2.0
/// Link to the color scheme https://colorscheme.ru/#4511Tw0w0w0w0

enum ColorSchemeId: Int {
  case v1
  case v2
}

public struct ColorScheme {
  let arrayColorSchemes: [ColorSchemeId: ColorType] = [.v1: ColorType(mainColor:                                                                    UIColor.rgb(50, 112, 157),
                                                                      darkMainColor: UIColor.rgb(30, 73, 101),
                                                                      lightDarkMainColor: UIColor.rgb(51, 93, 118),
                                                                      lightMainColor: UIColor.rgb(89, 161, 204),
                                                                      extraLightMainColor: UIColor.rgb(117, 173, 205)),
                                                       .v2: ColorType(mainColor: UIColor.rgb(38, 25, 170),
                                                                      darkMainColor: UIColor.rgb(17, 8, 110),
                                                                      lightDarkMainColor: UIColor.rgb(55, 47, 128),
                                                                      lightMainColor: UIColor.rgb(89, 77, 208),
                                                                      extraLightMainColor: UIColor.rgb(122, 113, 209))]
}


