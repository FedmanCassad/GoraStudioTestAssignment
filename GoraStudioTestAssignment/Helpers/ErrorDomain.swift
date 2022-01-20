//
//  ErrorDomain.swift
//  GoraStudioTestAssignment
//
//  Created by Vladimir Banushkin on 19.01.2022.
//

import Foundation

/// Self-made error domain
enum ErrorDomain: Error {
    case networkError(error: Error)
    case parsingError

    var description: (title: String, error: String) {
        switch self {
        case .networkError(error: let error):
            return ("Network error", error.localizedDescription)
        case .parsingError:
            return ("Error parsing received data", "Ask your dumb developer to fix this issue.")
        }
    }
}
