//
//  RemoteConfigAdapter.swift
//  Boquila
//
//  Created by Levi Bostian on 6/23/20.
//

import Foundation

public protocol RemoteConfigAdapter {
    func getValue<T: Codable>(id: String, map: ((String) -> String)?) -> T?
    func getValue<T: Codable>(id: String, defaultValue: T, map: ((String) -> String)?) -> T
    func activate()
    func refresh(onComplete: @escaping (Result<Void, Error>) -> Void)
}

public extension RemoteConfigAdapter {
    func getValue<T: Codable>(id: String, map: ((String) -> String)? = nil) -> T? {
        self.getValue(id: id, map: map)
    }
    
    func getValue<T: Codable>(id: String, defaultValue: T, map: ((String) -> String)? = nil) -> T {
        self.getValue(id: id, defaultValue: defaultValue, map: map)
    }
}
