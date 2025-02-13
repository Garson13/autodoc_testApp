//
//  ViewModelProtocol.swift
//  AutodocTest
//
//  Created by Гарик on 12.02.2025.
//

import Combine

protocol ViewModelProtocol: AnyObject {
    /// Получение данных
    func getData()
}

protocol LoadableViewModelProtocol: ViewModelProtocol {
    /// Сабджект издающий события смены состояния загрузки
    var loadingStateSubject: CurrentValueSubject<LoadingState, Never> {get}
}


