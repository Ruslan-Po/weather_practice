//
//  SceneDelegate.swift
//  PETweather
//
//  Created by Ruslan Popovich on 20/10/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)

        
        if let location = LocationStorageManager.load() {
            transitionToMainView(city: location.city, coordinate: location.coordinates)
        } else {
            let inputVC = InputViewController()
            inputVC.delegate = self
            self.window?.rootViewController = inputVC
        }
        self.window?.makeKeyAndVisible()
    }
    
    private func transitionToMainView(city: String? = nil , coordinate: LocationCoordinates? = nil){
        let mainVC = MainViewController()
        mainVC.inicialCoordinates = coordinate
        mainVC.inicialCityName = city
        let navVC = UINavigationController(rootViewController: mainVC)
        self.window?.rootViewController = navVC
    }
}

extension SceneDelegate: InputViewControllerDelegate {
    func didSelectCity(_ city: String) {
        let locationToSave = LastLocation(city: city)
        LocationStorageManager.save(locationToSave)
        transitionToMainView(city: city)
    }
    func didSelectCoordinate(_ coordinate: LocationCoordinates) {
        let locationToSave = LastLocation(coordinates: coordinate)
        LocationStorageManager.save(locationToSave)
        transitionToMainView(coordinate: coordinate)
    }
}
