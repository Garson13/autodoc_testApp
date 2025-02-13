//
//  LoadingState.swift
//  AutodocTest
//
//  Created by Гарик on 13.02.2025.
//

import Foundation

/// Перечисление с разными статусами загрузки, помогает следить за статусами и менять стейт
enum LoadingState {
    
    /// Состояние загрузки, загружено, завершено ошибкой соответственно
    case isLoading, loaded, error
}
