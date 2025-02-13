//
//  NewsListModel.swift
//  AutodocTest
//
//  Created by Гарик on 10.02.2025.
//

import Foundation

/// Модель для получения данных из сервера
struct NewsListModel: Decodable {
    let news: [NewsModel]
}

/// Вспомогаетльная модель для получения данных по новости из сервера
struct NewsModel: Decodable {
    let id: Int
    let title: String
    let description: String
    let publishedDate: String
    let url: String
    let fullUrl: String
    let titleImageUrl: String
    let categoryType: String
}
