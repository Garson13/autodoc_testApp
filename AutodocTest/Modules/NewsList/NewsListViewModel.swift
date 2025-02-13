//
//  NewsListViewModel.swift
//  AutodocTest
//
//  Created by Гарик on 10.02.2025.
//

import Combine
import Foundation

protocol NewsListViewModelProtocol: LoadableViewModelProtocol {
    
    /// Перейти на экран детальной новости
    func openDetailNews(news: NewsListCellModel)
    
    /// Сабджект издающий данные с массивом наших новостей
    var itemsSubject: PassthroughSubject<[NewsListCellModel], Never> {get}
}

/// `ViewModel` для  экрана со списком новостей
final class NewsListViewModel: NewsListViewModelProtocol {
    
    // MARK: - Public Properties

    /// Сабджект издающий данные с массивом наших новостей
    var itemsSubject = PassthroughSubject<[NewsListCellModel], Never>()
    
    /// Сабджект издающий состояния загрузки данных
    var loadingStateSubject = CurrentValueSubject<LoadingState, Never>(.isLoading)
    
    // MARK: - Private Properties
    
    /// Сервис для получения данных
    private let service: NewsListServiceProtocol
    
    /// Координатор
    private let coordinator: NewsListCoordinatorProtocol?
    
    // MARK: - Init

    init(service: NewsListServiceProtocol,
         coordinator: NewsListCoordinatorProtocol
    ) {
        self.service = service
        self.coordinator = coordinator
    }
    
    // MARK: - Private Methods

    /// Получение новостей
    /// - Returns: NewsListModel (модель  новостей)
    private func getNews() async -> NewsListModel {
        await service.getNews()
    }
    
    /// Преобразования модели полученные с сервера в модель данных ячейки
    ///  - Parameters:
    ///   - model: NewsListModel
    ///  - Returns: Массив преобразованных данных, готовых для отображения
    private func transformData(model: NewsListModel) async -> [NewsListCellModel]{
        
        var transformedNews: [NewsListCellModel] = []
         
         for news in model.news {
             let data = await service.getImageData(url: news.titleImageUrl)
             let cellModel = NewsListCellModel(
                 imageData: data,
                 title: news.title,
                 publishedDate: news.publishedDate.parseToDateFormat,
                 categoryType: news.categoryType,
                 description: news.description,
                 newsUrl: news.fullUrl
             )
             transformedNews.append(cellModel)
         }
        
        return transformedNews
    }
    
    // MARK: - Public Methods

    /// Получение данных
    func getData() {
        
        if loadingStateSubject.value != .isLoading {
            loadingStateSubject.send(.isLoading)
        }
        
        Task {
            let listNews = await getNews()
            if listNews.news.isEmpty {
                loadingStateSubject.send(.error)
                return
            }
            let transformedItems = await transformData(model: listNews)
            loadingStateSubject.send(.loaded)
            itemsSubject.send(transformedItems)
        }
    }
    
    /// Открыть детальный экран с новостями
    /// - Parameters: Модель с новостью
    func openDetailNews(news: NewsListCellModel) {
        coordinator?.openDetailNews(news: news)
    }
}
