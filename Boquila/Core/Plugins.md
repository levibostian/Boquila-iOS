# Plugins 

To make Boquila more powerful, it includes a plugin system designed to help you do more with your remote config values. 

At this time, Boquila has the following *types* of plugins available:
* `RemoteConfigAdapterPlugin` - Plugins that get executed by a remote config adapter. Modify the remote config adapter's string value it got from the server, transform the string into a different value, and get notified about lifecycle events of the remote config adapter. 

# How to use plugins

Using plugins is quite simple. All you need to do is pass in plugin instances into your `RemoteConfigAdapter` instances. 

Here is an example:

```swift
let jsonPlugin = JsonRemoteConfigAdapterPlugin()

let remoteConfigAdapter: RemoteConfigAdapter = FirebaseRemoteConfigAdapter(firebaseRemoteConfig: firebaseRemoteConfig, development: false, plugins: [jsonPlugin])
```

That's it! The plugins will now execute for you. 

*Note: The order that you provide your plugins to your `RemoteConfigAdapter` instance is very important as the plugins will get executed in that order.*

# Built-in plugins 

### `JsonRemoteConfigAdapterPlugin`

Plugin that takes the string value returned from your remote config service and tries to convert that value into an object. This plugin works great if use Json strings for remote config values. 

You can pass in custom instances of `JSONEncoder` or `JSONDecoder` if you wish:
```swift
let jsonPlugin = JsonRemoteConfigAdapterPlugin(jsonEncoder: JSONEncoder = JSONEncoder(), jsonDecoder: JSONDecoder = JSONDecoder())
```

You may set a delegate on the plugin for extra functionality:
```swift
let jsonPlugin = JsonRemoteConfigAdapterPlugin()
jsonPlugin.delegate = self
```

Notes:
* If the string value is not a valid string, the plugin will skip and not run. 

### `PrintLoggingRemoteConfigAdapterPlugin` 

A plugin that prints statements to XCode console using `print()`. 

# How to develop your own plugins 

These docs could be improved for this section. But in the mean time, check out the source code file for the `RemoteConfigAdapterPlugin` protocol and read the built-in plugins for examples. 