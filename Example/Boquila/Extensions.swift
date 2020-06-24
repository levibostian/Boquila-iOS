//
//  Extensions.swift
//  Boquila
//
//  Created by Levi Bostian on 6/24/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

extension Data {
    
    var string: String? {
        String(data: self, encoding: .utf8)
    }
}
