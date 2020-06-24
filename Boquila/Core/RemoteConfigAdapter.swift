//
//  RemoteConfigAdapter.swift
//  Boquila
//
//  Created by Levi Bostian on 6/23/20.
//

import Foundation

public protocol RemoteConfigAdapter {
    func getValue<T: Codable>(id: String) -> T?
    func activate()
    func refresh(onComplete: @escaping (Result<Void, Error>) -> Void)
}

public extension RemoteConfigAdapter {
    func getValue<T: Codable>(id: String, defaultValue: T) -> T {
        self.getValue(id: id) ?? defaultValue
    }
}
