import FirebaseRemoteConfig

public class FirebaseRemoteConfigAdapter: RemoteConfigAdapter {
    
    let firebaseRemoteConfig: RemoteConfig
    
    let jsonEncoder: JSONEncoder
    let jsonDecoder: JSONDecoder
        
    public init(firebaseRemoteConfig: RemoteConfig, jsonEncoder: JSONEncoder = JSONEncoder(), jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.firebaseRemoteConfig = firebaseRemoteConfig
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
        
        if BoquilaConfig.shared.isDebug {
            let settings = self.firebaseRemoteConfig.configSettings
            settings.minimumFetchInterval = 0
            self.firebaseRemoteConfig.configSettings = settings
        }
    }
    
    public func getValue<T>(id: String, map: ((String) -> String)? = nil) -> T? where T : Decodable, T : Encodable {
        guard let stringValue = self.firebaseRemoteConfig[id].stringValue else {
            return nil
        }
        // firebase returns empty values when a remote config value does not exist.
        guard !stringValue.isEmpty else {
            return nil
        }
        
        // try to convert the string into an object. If it doesn't happen, return nil and log error
        do {
            return try jsonDecoder.decode(T.self, from: stringValue.data(using: .utf8)!)
        } catch let error {
            BoquilaConfig.shared.errorHandler?(BoquilaError.stringDecoding(rawError: error))
            
            return nil
        }
    }
    
    public func getValue<T>(id: String, defaultValue: T, map: ((String) -> String)? = nil) -> T where T : Decodable, T : Encodable {
        self.getValue(id: id, map: map) ?? defaultValue
    }
    
    public func activate() {
        self.firebaseRemoteConfig.activateFetched()
    }
    
    public func refresh(onComplete: @escaping (Result<Void, Error>) -> Void) {
        self.firebaseRemoteConfig.fetch { (status, error) in
            if status == .success {
                onComplete(Result.success(Void()))
            } else if let error = error {
                onComplete(Result.failure(error))
            }
        }
    }
    
}
