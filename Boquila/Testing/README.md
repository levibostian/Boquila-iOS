# Testing

# Getting started 

This Testing module is designed to be flexible in order to be used in any of your tests: unit, integration, or UI tests. 

Here is some sample code on how to use it:

```swift
let adapter: RemoteConfigAdapter = MockRemoteConfigAdapter(jsonEncoder: JSONEncoder(), jsonDecoder: JSONDecoder())
adapter.setValue(id: "id", value: [1, 2, 3])

// You can use dependency injection to inject the `adapter` instance into your code under test. 
// That way when your code under test now will call...
let value: [Int] = adapter.getValue(id: "id")
// ...they will get the value that you set!
```

Some of the functions of `RemoteConfigAdapter` have some convenient properties you can use to make sure your app is behaving accordingly:

```swift
// In your code under test, if if calls `activate()`...
adapter.activate()
// ...you can verify if it was called in your test        
XCTAssertEqual(adapter.activateCallsCount, 1)
```

# Using with UI tests

When you are writing UI tests for iOS, know that when your app launches it is as if your app is launched for the first time. 

However, with the help of `XCUIApplication.launchEnvironment`, you can communicate between the UI tests and the app under test. Use the Boquila testing module to easily set `launchEnvironment` and mock the app under test. 

```swift
// In your UI tests, you can set values.
let givenOverride = [1, 2, 3]
adapter.setValue(id: "id", value: givenOverride)
        
// Then, when launching the app for UI testing, you need to set launch environments using strings.
let valueOverridesString: String = try! jsonAdapter.toJson(adapter.valueOverrides).string!
        
// Then, when your app under test launches you will get the string from the launch environment. You then want to put that back into the app instance's mock adapter.
let appInstanceMockAdapter = MockRemoteConfigAdapter(jsonEncoder: jsonAdapter.encoder, jsonDecoder: jsonAdapter.decoder)
appInstanceMockAdapter.valueOverrides = try! jsonAdapter.fromJson(valueOverridesString.data(using: .utf8)!)

// Use dependency injection to inject `appInstanceMockAdapter` into your app. 

// Now when your app under test in your UI tests tries to retrieve the remote config value with id "id", they will get your set value.
```