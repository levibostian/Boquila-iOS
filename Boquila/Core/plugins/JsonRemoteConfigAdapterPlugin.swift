//
//  JsonRemoteConfigAdapterPlugin.swift
//  Boquila
//
//  Created by Levi Bostian on 6/24/20.
//

import Foundation

public enum JsonRemoteConfigAdapterPluginError: LocalizedError {
    case cannotTransformStringValue(message: String)

    public var errorDescription: String? {
        return localizedDescription
    }
    public var localizedDescription: String {
        switch self {
        case .cannotTransformStringValue(let message): return message
        }
    }
}

public protocol JsonRemoteConfigAdapterPluginDelegate: AnyObject {
    func shouldTransformValue(stringValue: String) -> Bool
    func errorHandler(error: Error)
}

public class JsonRemoteConfigAdapterPlugin: RemoteConfigAdapterPlugin {
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    
    public weak var delegate: JsonRemoteConfigAdapterPluginDelegate? = nil
        
    public init(jsonEncoder: JSONEncoder = JSONEncoder(), jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
    }
    
    public func transformValue<T: Codable>(_ value: Any) -> T? {
        guard let stringValue = value as? String else {
            return nil
        }
        if let delegate = self.delegate, !delegate.shouldTransformValue(stringValue: stringValue) {
            return nil
        }
        
        guard isValidJson(stringValue) else {
            return nil
        }
        
        do {
            return try jsonDecoder.decode(T.self, from: stringValue.data(using: .utf8)!)
        } catch let error {
            delegate?.errorHandler(error: error)
            
            return nil
        }
    }
    
    public func transformToStringValue<T: Codable>(_ value: T) -> String? {
        do {
            let data = try jsonEncoder.encode(value)
            
            return String(data: data, encoding: .utf8)
        } catch let error {
            delegate?.errorHandler(error: error)
            
            return nil
        }
    }
    
    func isValidJson(_ value: String) -> Bool {
        guard let data = value.data(using: .utf8) else {
            return false
        }
        
        return JSONSerialization.isValidJSONObject(data)
    }
    
}
