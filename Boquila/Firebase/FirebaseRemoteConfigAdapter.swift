import FirebaseRemoteConfig

public class FirebaseRemoteConfigAdapter: RemoteConfigAdapter {
    
    let firebaseRemoteConfig: RemoteConfig
    let plugins: [RemoteConfigAdapterPlugin]
            
    public init(firebaseRemoteConfig: RemoteConfig, development: Bool = false, plugins: [RemoteConfigAdapterPlugin] = []) {
        self.firebaseRemoteConfig = firebaseRemoteConfig
        self.plugins = plugins
        
        if development {
            let settings = self.firebaseRemoteConfig.configSettings
            settings.minimumFetchInterval = 0
            self.firebaseRemoteConfig.configSettings = settings
        }
    }
    
    public func getValue<T>(id: String) -> T? where T : Decodable, T : Encodable {
        guard var stringValue = self.firebaseRemoteConfig[id].stringValue else {
            return nil
        }
        // firebase returns empty values when a remote config value does not exist.
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
    
    public func activate() {
        self.plugins.forEach { plugin in
            plugin.activateBegin()
        }
        
        self.firebaseRemoteConfig.activateFetched()
    }
    
    public func refresh(onComplete: @escaping (Result<Void, Error>) -> Void) {
        self.plugins.forEach { plugin in
            plugin.refreshBegin()
        }
        
        self.firebaseRemoteConfig.fetch { (status, error) in
            var result: Result<Void, Error> = Result.success(Void())
            if let error = error {
                result = Result.failure(error)
            }
            
            self.plugins.forEach { plugin in
                plugin.refreshEnd(result: result)
            }
            
            onComplete(result)
        }
    }
    
}
