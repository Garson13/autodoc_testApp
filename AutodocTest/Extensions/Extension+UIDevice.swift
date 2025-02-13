//
//  Extension+UIDevice.swift
//  AutodocTest
//
//  Created by Гарик on 13.02.2025.
//

import UIKit

extension UIDevice {

    /// Является ли устройство iPad-ом
    static var isIPad: Bool {
        UIDevice().userInterfaceIdiom == .pad
    }
}
