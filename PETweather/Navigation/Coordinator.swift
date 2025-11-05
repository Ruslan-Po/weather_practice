
import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let storage: LocationStorageProtocol

    init(window: UIWindow, storage: LocationStorageProtocol) {
        self.window = window
        self.storage = storage
    }

    func start() {
        if let location = storage.load() {
            showMain(city: location.city, coordinate: location.coordinates)
        } else {
            showInput()
        }
        window.makeKeyAndVisible()
    }

    private func showInput() {
        let inputVC = InputViewController()
        inputVC.delegate = self
        window.rootViewController = inputVC
    }

    private func showMain(city: String? = nil, coordinate: LocationCoordinates? = nil) {
       
        let mainVC = MainViewController()
        mainVC.inicialCityName = city
        mainVC.inicialCoordinates = coordinate

        mainVC.presenter = WeatherPresenter(
            view: mainVC,
            greetings: Greetings(),
            localDatetimeHelper: DateTimeHelper(),
            imagesByCode: ImagesByCodeHelper()
        )
        mainVC.presenter?.inicialCityName = mainVC.inicialCityName
        mainVC.presenter?.inicialCoordinates = mainVC.inicialCoordinates
        let nav = UINavigationController(rootViewController: mainVC)
        window.rootViewController = nav
        mainVC.presenter?.getWeatherByInputResponse()
    }
}

extension AppCoordinator: InputViewControllerDelegate {
    func didSelectCity(_ city: String) {
        storage.save(LastLocation(city: city))
        showMain(city: city)
    }

    func didSelectCoordinate(_ coordinate: LocationCoordinates) {
        storage.save(LastLocation(coordinates: coordinate))
        showMain(coordinate: coordinate)
    }
}
