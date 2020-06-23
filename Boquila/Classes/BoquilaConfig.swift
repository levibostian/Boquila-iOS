
/**
 Mostly
 */
public class BoquilaConfig {
    /**
     Sigleton instance
     */
    public static var shared: BoquilaConfig = BoquilaConfig()
    
    /**
    Set the global string replacement prefix. This will be used with string replacement where the key that get replaced will be: `<prefix><key><suffix>` in your remote config value.
    */
    public var stringReplacePrefix: String = "{{"
    /**
    Set the global string replacement suffix. This will be used with string replacement where the key that get replaced will be: `<prefix><key><suffix>` in your remote config value.
    */
    public var stringReplaceSuffix: String = "}}"
    
    internal var stringReplacements: [String: String] = [:]
    
    /**
     Set handler for dynamic string replacement.
     
     Note: The string replacement suffix and prefix are *not* provided in the `key` parameter.
     
     Usage:
     ````
     BoquilaConfig.shared.stringReplacementHandler = { [weak self] (key) -> String? in
         switch key {
             case "app_version": return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
             default: return nil
         }
     }
     ````
     */
    public var stringReplacementHandler: ((_ key: String) -> String?)? = nil
    
    /**
     Set global handler for any error that can happen while using Boquila.
     
     Usage:
     ````
     BoquilaConfig.shared.errorHandler = { [weak self] (boquilaError) -> Void in
         switch boquilaError {
             case .unknownStringReplacement(let key, let error): break
         }
     }
     ````
     */
    public var errorHandler: ((BoquilaError) -> Void)? = nil

    private init() {
    }

    /**
     Clear all previously set string replacements.
     */
    public func clearStringReplacements() {
        self.stringReplacements = [:]
    }
    
    /**
     Add key/value pairs for string replacement.
     
     Note: For the key, do *not* include the string replacement prefix or suffix.
     */
    public func addStringReplacements(_ newReplacements: [String: String]) {
        var newReplacements = self.stringReplacements
        
        newReplacements.forEach { (arg) in
            let key = arg.key
            let value = arg.value
             
            newReplacements[key] = value
        }
        
        self.stringReplacements = newReplacements
    }
    
}
