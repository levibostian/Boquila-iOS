//
//  BoquilaError.swift
//  Boquila
//
//  Created by Levi Bostian on 6/23/20.
//

import Foundation

internal class BoquilaErrors {
    
    static func unknownStringReplacement(key: String) -> NSError {
        NSError(domain: "Unknown string replacement", code: 0, userInfo: [
            "key": key
        ])
    }
}

public enum BoquilaError: LocalizedError {
    case unknownStringReplacement(key: String, rawError: NSError)

    public var errorDescription: String? {
        return localizedDescription
    }
    public var localizedDescription: String {
        switch self {
        case .unknownStringReplacement(_, let raw): return raw.domain
        }
    }
}
