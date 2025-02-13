//
//  Extension+String.swift
//  AutodocTest
//
//  Created by Гарик on 12.02.2025.
//

import Foundation

extension String {
    
    /// Свойство, позволяющее форматировать строку в нужный нам во всем приложении формат даты
    /// Из`yyyy-MM-dd'T'HH:mm:ss` в `dd.MM.yyyy`
    var parseToDateFormat: Self {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let parsedDate = inputFormatter.date(from: self) else { return "" }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd.MM.yyyy"
        
        return outputFormatter.string(from: parsedDate)
    }
}
