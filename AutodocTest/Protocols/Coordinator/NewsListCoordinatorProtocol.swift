//
//  NewsListCoordinatorProtocol.swift
//  AutodocTest
//
//  Created by Гарик on 13.02.2025.
//

import Foundation

protocol NewsListCoordinatorProtocol: CoordinatorProtocol {
    
    /// Открыть детальный экран новостей - `DetailNewsViewController`
    /// - Parameters:
    ///  - news: Модель новости
    func openDetailNews(news: NewsListCellModel)
    
    /// Открыть полностью новость в `WebViewController`
    /// - Parameters:
    ///  - url: Ссылка на полную статью
    ///  - newsTitle: Заголовок новости
    func openFullNews(url: String, newsTitle: String?)
}
