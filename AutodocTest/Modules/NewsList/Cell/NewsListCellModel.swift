//
//  NewsListCellModel.swift
//  AutodocTest
//
//  Created by Гарик on 11.02.2025.
//

import UIKit

/// Модель ячейки в листе новостей для отображения в `NewsListViewController` и `DetailNewsViewController`
struct NewsListCellModel: Hashable {
    
    /// Картинка в формате `Data`
    let imageData: Data?
    
    /// Заголовок новости
    let title: String
    
    /// Дата публикации новости
    let publishedDate: String
    
    /// Категория новости
    let categoryType: String
    
    /// Описание новости
    let description: String
    
    /// Полная ссылка на статью
    let newsUrl: String
}
