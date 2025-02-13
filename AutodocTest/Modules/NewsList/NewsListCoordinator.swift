//
//  NewsListCoordinator.swift
//  AutodocTest
//
//  Created by Гарик on 13.02.2025.
//

import UIKit
import WebKit

/// Координатор для флоу с начальным экраном "Новостная лента" - `NewsListViewController`
final class NewsListCoordinator: NewsListCoordinatorProtocol  {
    
    // MARK: - Private Properties
    
    /// Навигационный контроллер
    private let navigationController: UINavigationController
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Public Methods
    
    /// Запуск стартового экрана в этом флоу
    func start() {
        let service = NewsListService()
        let viewModel = NewsListViewModel(service: service, coordinator: self)
        let viewController = NewsListViewController(viewModel: viewModel)
        navigationController.viewControllers = [viewController]
    }
    
    /// Открыть детальный экран новостей - `DetailNewsViewController`
    /// - Parameters:
    ///  - news: Модель новости
    func openDetailNews(news: NewsListCellModel) {
        let viewModel = DetailNewsViewModel(news: news, coordinator: self)
        let viewController = DetailNewsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    /// Открыть полностью новость в `WebViewController`
    /// - Parameters:
    ///  - url: Ссылка на полную статью
    ///  - newsTitle: Заголовок новости
    func openFullNews(url: String, newsTitle: String?) {
        guard let url = URL(string: url) else {return}
        let webViewController = WebViewController(url: url, newsTitle: newsTitle)
        navigationController.pushViewController(webViewController, animated: true)
    }
}

