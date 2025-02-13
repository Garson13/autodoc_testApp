//
//  AppCoordinator.swift
//  AutodocTest
//
//  Created by Гарик on 13.02.2025.
//

import UIKit

/// Объект, отвечающий за навигацию в приложении глобально на старте приложения
final class AppCoordinator: CoordinatorProtocol {
    
    // MARK: - Private Properties

    /// Текущее окно
    private var window: UIWindow
    
    /// Главный навигационный контроллер
    private var navigationController: UINavigationController
    
    // MARK: - Init

    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    // MARK: - Public methods

    /// Метод запускающий нужный флоу
    /// В данный момент у нас один рутовый экран, поэтому реализовано так
    /// Если в приложении будет больше экранов, то будет менять логику, где будет разное ответвление в зависимости от требований
    func start() {
        let newsCoordinator = NewsListCoordinator(navigationController: navigationController)
        newsCoordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
