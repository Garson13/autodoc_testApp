//
//  DetailNewsViewModel.swift
//  AutodocTest
//
//  Created by Гарик on 13.02.2025.
//

import Combine
import Foundation

protocol DetailNewsViewModelProtocol {
    
    /// Сабджект, издающий события с моделью новости
    var newsSubject: CurrentValueSubject<NewsListCellModel, Never> {get}
    
    /// Открыть новость в `WKWebView`
    func openNewsForWebView()
    
}

/// `ViewModel` для детального экрана новости
final class DetailNewsViewModel: DetailNewsViewModelProtocol {
    
    // MARK: - Private Properties

    /// Собственный координатор
    private let coordinator: NewsListCoordinatorProtocol?
    
    // MARK: - Public Properties

    /// Сабджект, издающий события с моделью новости
    var newsSubject: CurrentValueSubject<NewsListCellModel, Never>
    
    // MARK: - Init

    init(news: NewsListCellModel, coordinator: NewsListCoordinatorProtocol) {
        self.coordinator = coordinator
        newsSubject = CurrentValueSubject<NewsListCellModel, Never>(news)
    }
    
    // MARK: - Public Methods

    /// Открыть новость в `WKWebView`
    func openNewsForWebView() {
        coordinator?.openFullNews(
            url: newsSubject.value.newsUrl,
            newsTitle: newsSubject.value.title
        )
    }
}
