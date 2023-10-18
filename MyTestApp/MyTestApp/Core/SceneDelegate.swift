//
//  SceneDelegate.swift
//  MyTestApp
//
//  Created by  user on 04.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    self.window = UIWindow(windowScene: windowScene)
    window?.overrideUserInterfaceStyle = .light
    //let rootVc = MainViewController()
    //let rootVc = HomeViewController()
    //let rootVc = AnimateChartViewController()
    //let rootVc = GestureRecognizeViewController()
    //let rootVc = ControlledCATransform3DViewController()
    //let rootVc = ControlledCATransform3DViewControllerV2()
    //let rootVc = AnimateButtonViewController()
    //let rootVc = SceneKitViewController()
    let rootVc = AdvancedGradientAnimationViewController()
    window?.rootViewController = rootVc
    window?.makeKeyAndVisible()
  }
}

