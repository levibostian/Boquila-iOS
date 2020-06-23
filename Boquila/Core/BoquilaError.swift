//
//  BoquilaError.swift
//  Boquila
//
//  Created by Levi Bostian on 6/23/20.
//

import Foundation

/**
 We use `NSError` because some services such as Firebase Crashlytics work better with NSError. Because NSError is an instance of Error, devs who don't need NSError can use this as a regular Error instance.
 */
internal class BoquilaErrors {
    
    static func stringDecoding(rawError: Error) -> NSError {
        NSError(domain: rawError.localizedDescription, code: 0, userInfo: nil)
    }
}

public enum BoquilaError: LocalizedError {
    case stringDecoding(rawError: Error)

    public var errorDescription: String? {
        return localizedDescription
    }
    public var localizedDescription: String {
        switch self {
        case .stringDecoding(let raw): return raw.localizedDescription
        }
    }
}
