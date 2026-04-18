//
//  String+extension.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 01.12.2024.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(
            self, comment: "\(self) could not be found in Localizable.strings"
        )
    }
}
