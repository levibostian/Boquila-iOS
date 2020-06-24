public enum MockRemoteConfigAdapterError: LocalizedError {
    case cannotTransformToStringValue(message: String)

    public var errorDescription: String? {
        return localizedDescription
    }
    public var localizedDescription: String {
        switch self {
        case .cannotTransformToStringValue(let message): return message
        }
    }
}

public class MockRemoteConfigAdapter: RemoteConfigAdapter {

    private let plugins: [RemoteConfigAdapterPlugin]
    
    public init(plugins: [RemoteConfigAdapterPlugin] = []) {
        self.plugins = plugins
    }
    
    /**
     Stores the values you want to override in the mock.
     
     This is important to stay as a `Codable` so it can be encoded/decoded if it needs to be used for UI tests.
     */
    public var valueOverrides: [String: String] = [:]
    
    /**
     Attempts to transform the value you pass into something else usable
     */
    public func setValue(id: String, value: String) {
        self.valueOverrides[id] = value
    }
    
    public func setValue<T: Codable>(id: String, value: T) throws {
        var transformedValue: String? = nil
        self.plugins.forEach { (plugin) in
            if transformedValue == nil {
                transformedValue = plugin.transformToStringValue(value)
            }
        }
            
        guard let stringValue = transformedValue else {
            throw MockRemoteConfigAdapterError.cannotTransformToStringValue(message: "No plugins you provided were able to set the value. Provide different plugins.")
        }
        
        self.setValue(id: id, value: stringValue)
    }
            
    public var getValueCallsCount = 0
    public var getValueCalled: Bool {
        return getValueCallsCount > 0
    }
    public func getValue<T: Codable>(id: String) -> T? {
        guard var stringValue = valueOverrides[id] else {
            return nil
        }
        guard !stringValue.isEmpty else {
            return nil
        }
        
        // Allow plugins to transform the input string.
        self.plugins.forEach { plugin in
            stringValue = plugin.manipulateStringValue(stringValue)
        }
        
        // Transform the string value into something else. Allow the plugins to do this for us.
        var transformedValue: T? = nil
        self.plugins.forEach { plugin in
            if transformedValue == nil {
                transformedValue = plugin.transformStringValue(stringValue)
            }
        }
        
        return transformedValue
    }
    
    public var activateCallsCount = 0
    public var activateCalled: Bool {
        return activateCallsCount > 0
    }
    public var activateClosure: (() -> Void)?
    public func activate() {
        self.plugins.forEach { plugin in
            plugin.activateBegin()
        }
        
        activateCallsCount += 1
        activateClosure?()
    }
    
    public var refreshCallsCount = 0
    public var refreshCalled: Bool {
        return refreshCallsCount > 0
    }
    public var refreshClosure: (() -> Result<Void, Error>)?
    public func refresh(onComplete: @escaping (Result<Void, Error>) -> Void) {
        self.plugins.forEach { plugin in
            plugin.refreshBegin()
        }
        
        let result = refreshClosure!()
        
        self.plugins.forEach { plugin in
            plugin.refreshEnd(result: result)
        }
        
        refreshCallsCount += 1
        onComplete(result)
    }
}
