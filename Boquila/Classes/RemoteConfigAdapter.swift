//
//  RemoteConfigAdapter.swift
//  Boquila
//
//  Created by Levi Bostian on 6/23/20.
//

import Foundation

internal protocol RemoteConfigAdapter {
    func getValue<T: Codable>(id: String) -> T?
    func getValue<T: Codable>(id: String, defaultValue: T) -> T
    func activate()
    func refresh(onComplete: () -> Void)
    func addInstanceStringReplacements(_ replacements: [String: String])
}
