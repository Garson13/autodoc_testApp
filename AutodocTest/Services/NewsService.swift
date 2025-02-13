//
//  NewsService.swift
//  AutodocTest
//
//  Created by Гарик on 10.02.2025.
//

import Foundation

protocol NewsListServiceProtocol {
    
    /// Получение новостей
    /// - Returns: NewsListModel (модель  новостей)
    func getNews() async -> NewsListModel
    
    /// Получение данных для отображения картинки
    /// - Parameters:
    ///  - url: Адрес для получения данных
    /// - Returns: Данные для отображения картинки
    func getImageData(url: String) async -> Data?
}

final class NewsListService: NewsListServiceProtocol {
    
    // MARK: - Private Properties
    
    private let url = "https://webapi.autodoc.ru/api/news/1/15"

    // MARK: - Public Methods
    
    /// Получение новостей
    /// - Returns: NewsListModel (модель  новостей)
    func getNews() async -> NewsListModel {
        guard let url = URL(string: url) else { return .init(news: [])}
        let urlRequest = URLRequest(url: url)
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            return try JSONDecoder().decode(NewsListModel.self, from: data)
        } catch {
            print("error")
        }
        return .init(news: [])
    }
    
    /// Получение данных для отображения картинки
    /// - Parameters:
    ///  - url: Адрес для получения данных
    /// - Returns: Данные для отображения картинки
    func getImageData(url: String) async -> Data? {
        
        guard let url = URL(string: url) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            print("error")
        }
        return nil
    }
}
