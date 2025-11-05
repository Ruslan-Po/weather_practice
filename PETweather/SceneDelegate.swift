//
//  SceneDelegate.swift
//  PETweather
//
//  Created by Ruslan Popovich on 20/10/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var coordinator: Coordinator?
    
    func scene(_ scene: UIScene,
                 willConnectTo session: UISceneSession,
                 options connectionOptions: UIScene.ConnectionOptions) {
          guard let winScene = (scene as? UIWindowScene) else { return }
          let window = UIWindow(windowScene: winScene)

          let storage = LocationStorageAdapter()

          let coordinator = AppCoordinator(window: window, storage: storage)
          self.window = window
          self.coordinator = coordinator

          coordinator.start()
      }
}
