
public class MockRemoteConfigAdapter: RemoteConfigAdapter {
    
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    
    public init(jsonEncoder: JSONEncoder, jsonDecoder: JSONDecoder) {
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
    }
    
    /**
     Stores the values you want to override in the mock.
     
     This is important to stay as a `Codable` so it can be encoded/decoded if it needs to be used for UI tests.
     */
    public struct ValueOverrides: Codable {
        public let values: [String: Data]
        
        public init(values: [String: Data]) {
            self.values = values
        }
    }
    
    public var valueOverrides: ValueOverrides = ValueOverrides(values: [:])
    
    public var valueOverridesString: String {
        get {
            try! self.jsonEncoder.encode(self.valueOverrides).string!
        }
        set {
            self.valueOverrides = try! self.jsonDecoder.decode(ValueOverrides.self, from: newValue.data(using: .utf8)!)
        }
    }
    
    public func setValue<T: Codable>(id: String, value: T) {
        let value = try! self.jsonEncoder.encode(value)
        
        var oldValueOverrides = self.valueOverrides.values
        oldValueOverrides[id] = value
        
        self.valueOverrides = ValueOverrides(values: oldValueOverrides)
    }
            
    public var getValueCallsCount = 0
    public var getValueCalled: Bool {
        return getValueCallsCount > 0
    }
    public func getValue<T: Codable>(id: String) -> T? {
        guard let value = valueOverrides.values[id] else {
            return nil
        }
        
        return try! self.jsonDecoder.decode(T.self, from: value)
    }
    
    public var activateCallsCount = 0
    public var activateCalled: Bool {
        return activateCallsCount > 0
    }
    public var activateClosure: (() -> Void)?
    public func activate() {
        activateCallsCount += 1
        activateClosure?()
    }
    
    public var refreshCallsCount = 0
    public var refreshCalled: Bool {
        return refreshCallsCount > 0
    }
    public var refreshClosure: (() -> Result<Void, Error>)?
    public func refresh(onComplete: @escaping (Result<Void, Error>) -> Void) {
        refreshCallsCount += 1
        onComplete(refreshClosure!())
    }
}
