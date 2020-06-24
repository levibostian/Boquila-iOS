//
//  Extensions.swift
//  Boquila
//
//  Created by Levi Bostian on 6/24/20.
//

import Foundation

internal extension Data {
    var string: String? {
        String(data: self, encoding: .utf8)
    }
}
