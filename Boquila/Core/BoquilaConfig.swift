
/**
 Mostly
 */
public class BoquilaConfig {
    /**
     Sigleton instance
     */
    public static var shared: BoquilaConfig = BoquilaConfig()
    
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
    
    /**
     Enable/disable debug mode. Debug mode is intended to be used during development.
     */
    public var isDebug: Bool = false

    private init() {
    }
    
}
