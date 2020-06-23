# Firebase 

# Getting started 

```swift
import UIKit
import Boquila
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Better to do in AppDelegate...
        FirebaseApp.configure()
        
        let firebaseRemoteConfig = RemoteConfig.remoteConfig()
        let remoteConfigAdapter: RemoteConfigAdapter = FirebaseRemoteConfigAdapter(firebaseRemoteConfig: firebaseRemoteConfig)
        
        let optionalStringValue: String? = remoteConfigAdapter.getValue(id: "optional_string_value")
        let nonoptionalStringValue: String? = remoteConfigAdapter.getValue(id: "optional_string_value", defaultValue: "Default value")
        
        let nonStringValue: NonStringValue? = remoteConfigAdapter.getValue(id: "non_string_value")
    }
    
    struct NonStringValue: Codable {
        let foo: Bool
        let bar: [String]
    }

}
```