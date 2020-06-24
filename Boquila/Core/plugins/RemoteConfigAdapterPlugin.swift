//
//  GetValuePlugin.swift
//  Boquila
//
//  Created by Levi Bostian on 6/24/20.
//

import Foundation

/**
 Plugin for a `RemoteConfigAdapter` instance.
 
 Each function is optional (as a default implementation is made for you).
 
 It's recommended that your plugin contains try/catch statements and log those errors if there is a chance for that. Errors are not handled in the remote config adapter.
 */
public protocol RemoteConfigAdapterPlugin {
    /**
     Change the string value into a new result. Great opportunity to perform string replacements.
     
     If you don't need to manipulate the original value, return `stringValue`. Do not return an empty string or all of your adapters will return an empty string.
     */
    func manipulateStringValue(_ stringValue: String) -> String
    /**
     Transform the string value into another value. Return `nil` if your plugin cannot or should not transform the string value. The first plugin to return a non-nil value from this function is what value gets returned.
     
     It's a good idea to (1) check `value` is a format that your plugin knows how to handle. For example, if you're building a plugin that transforms strings in JSON format into an object, run a check on the `value` to see if it's valid json and if not, return `nil`. This is a good idea because **the first plugin that returns a non-nil value is the value returned from the adapter's `getValue()` function**.
     */
    func transformStringValue<T: Codable>(_ value: String) -> T?
    /**
     The opposite of `transformStringValue` where your plugin will attempt to take a value that could be returned from `transformStringValue` and convert it back into a string.
     
     If your plugin implements `transformStringValue`, it's a good idea to also implement this function.
     */
    func transformToStringValue<T: Codable>(_ value: T) -> String?
    /**
     Before the activation for the adapter is started, this is called.
     */
    func activateBegin()
    /**
     Before the refresh action for the adapter is started, this is called.
     */
    func refreshBegin()
    /**
     After the refresh action for the adapter is done, this is called with the refresh result.
     */
    func refreshEnd(result: Result<Void, Error>)
}

public extension RemoteConfigAdapterPlugin {
    func manipulateStringValue(_ stringValue: String) -> String { return stringValue }
    func transformStringValue<T: Codable>(_ value: String) -> T? { return nil }
    func transformToStringValue<T: Codable>(_ value: T) -> String? { return nil }
    func activateBegin() { }
    func refreshBegin() { }
    func refreshEnd(result: Result<Void, Error>) { }
}
