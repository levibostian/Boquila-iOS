# Testing

# Getting started 

This Testing module is designed to be flexible in order to be used in any of your tests: unit, integration, or UI tests. 

Here is some sample code on how to use it:
```swift
let adapter: RemoteConfigAdapter = MockRemoteConfigAdapter()
adapter.setValue(id: "contact-us-phone", value: "555-555-5555")

// You can use dependency injection to inject the `adapter` instance into your code under test. 
// That way when your code under test now will call...
let phoneNumber: String = adapter.getValue(id: "contact-us-phone")
// ...they will get the value that you set!
```

Some of the functions of `RemoteConfigAdapter` have some convenient properties you can use to make sure your app is behaving accordingly:

```swift
// In your code under test, if if calls `activate()`...
adapter.activate()
// ...you can verify if it was called in your test        
XCTAssertEqual(adapter.activateCallsCount, 1)
```

##### Plugins

`MockRemoteConfigAdapter` is able to use plugins. It is recommended to use plugins if you use them for other adapters in your app. 
```swift
MockRemoteConfigAdapter(plugins: [...])
```

*Note: If you call `mockAdapter.setValue()` with a value that is not a String, the `MockRemoteConfigAdapter` will use the plugins to try and transform the given value into a string. If the adapter is unsuccessful doing this, it will throw an error.*

# Using with UI tests

When you are writing UI tests for iOS, know that when your app launches it is as if your app is launched for the first time. 

However, with the help of `XCUIApplication.launchEnvironment`, you can communicate between the UI tests and the app under test. Use the Boquila testing module to easily set `launchEnvironment` and mock the app under test. 

```swift
// In your UI tests, you can set values.
let givenOverride = [1, 2, 3]
try! adapter.setValue(id: "id", value: givenOverride) // Make sure to add plugins to your adapter to avoid an error being thrown!
        
// Then, when launching the app for UI testing, you need to set launch environments using strings.
let valueOverridesString: String = adapter.valueOverrides
XCUIApplication.launchEnvironment["remote_config"] = valueOverridesString
        
// Then, when your app under test launches you will get the string from the launch environment. You then want to put that back into the app instance's mock adapter.
let appInstanceMockAdapter = MockRemoteConfigAdapter()
let valueOverridesString = application.launchEnvironment["remote_config"]
appInstanceMockAdapter.valueOverrides = valueOverridesString
// Use dependency injection to inject `appInstanceMockAdapter` into your app. 

// Now when your app under test in your UI tests tries to retrieve the remote config value with id "id", they will get your set value.
```