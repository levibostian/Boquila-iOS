//
//  MockRemoteConfigAdapterTest.swift
//  Boquila_Tests
//
//  Created by Levi Bostian on 6/24/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
import Boquila

class MockRemoteConfigAdapterTest: XCTestCase {
    
    private var adapter: MockRemoteConfigAdapter!
    private let jsonAdapter = SwiftJsonAdpter()
    
    override func setUp() {
        super.setUp()
        
        adapter = MockRemoteConfigAdapter(jsonEncoder: jsonAdapter.encoder, jsonDecoder: jsonAdapter.decoder)
    }
    
    // MARK: - activate
    
    func test_activate_givenCallFunction_expectCallsCountIncrement() {
        XCTAssertEqual(adapter.activateCallsCount, 0)
        
        adapter.activate()
        
        XCTAssertEqual(adapter.activateCallsCount, 1)
        
        adapter.activate()
        
        XCTAssertEqual(adapter.activateCallsCount, 2)
    }
    
    func test_activate_givenCallFunction_expectCalledTrue() {
        XCTAssertFalse(adapter.activateCalled)
        
        adapter.activate()
        
        XCTAssertTrue(adapter.activateCalled)
        
        adapter.activate()
        
        XCTAssertTrue(adapter.activateCalled)
    }
    
    func test_activate_givenCallFunction_expectCallClosure() {
        var closureCalled = false
        
        adapter.activateClosure = {
            closureCalled = true
        }
        
        XCTAssertFalse(closureCalled)
        
        adapter.activate()
        
        XCTAssertTrue(closureCalled)
        
        adapter.activate()
        
        XCTAssertTrue(closureCalled)
    }
    
    // MARK: - refresh
    
    func test_refresh_givenCallFunction_expectCallsCountIncrement() {
        adapter.refreshClosure = {
            Result.success(Void())
        }
        
        XCTAssertEqual(adapter.refreshCallsCount, 0)
        
        adapter.refresh(onComplete: { (_) in
            XCTAssertEqual(self.adapter.refreshCallsCount, 1)
        })
    }
    
    func test_refresh_givenCallFunction_expectCalledTrue() {
        adapter.refreshClosure = {
            Result.success(Void())
        }
        
        XCTAssertFalse(adapter.refreshCalled)
        
        adapter.refresh(onComplete: { (_) in
            XCTAssertTrue(self.adapter.refreshCalled)
        })
    }
    
    func test_refresh_givenCallFunction_expectCallClosure() {
        var closureCalled = false
        
        adapter.refreshClosure = {
            closureCalled = true
            
            return Result.success(Void())
        }
        
        XCTAssertFalse(closureCalled)
                
        adapter.refresh(onComplete: { (_) in
            XCTAssertTrue(closureCalled)
        })
    }
    
    // MARK: - setValue
    
    func test_setValue_givenNeverCalled_expectValueOverridesEmpty() {
        XCTAssertEqual(adapter.valueOverrides.values, [:])
    }
    
    func test_setValue_givenCallWithValue_expectValueOverridesContainsEntry() {
        let id = "id"
        let givenValue = "foo"
        
        adapter.setValue(id: id, value: givenValue)
        
        XCTAssertEqual(adapter.valueOverrides.values.keys.count, 1)
        let actual: String = try! jsonAdapter.fromJson(adapter.valueOverrides.values[id]!)
        XCTAssertEqual(givenValue, actual)
    }
    
    func test_setValue_givenCallWithValueTwice_expectValueOverridesContainsLatestEntry() {
        let id = "id"
        let oldValue = "oldValue"
        let newValue = "newValue"
        
        adapter.setValue(id: id, value: oldValue)
        adapter.setValue(id: id, value: newValue)
        
        XCTAssertEqual(adapter.valueOverrides.values.keys.count, 1)
        let actual: String = try! jsonAdapter.fromJson(adapter.valueOverrides.values[id]!)
        XCTAssertEqual(newValue, actual)
    }
    
    func test_setValue_givenCallWithValueDifferentKeys_expectValueOverridesContainsBothEntries() {
        adapter.setValue(id: "first", value: "first-value")
        adapter.setValue(id: "second", value: "second-value")
        
        XCTAssertEqual(adapter.valueOverrides.values.keys.count, 2)
        let actualFirstValue: String = try! jsonAdapter.fromJson(adapter.valueOverrides.values["first"]!)
        let actualSecondValue: String = try! jsonAdapter.fromJson(adapter.valueOverrides.values["second"]!)
        XCTAssertEqual(actualFirstValue, "first-value")
        XCTAssertEqual(actualSecondValue, "second-value")
    }
    
    // MARK: - valueOverrides
    
    func test_valueOverrides_givenNewInstance_expectEmpty() {
        XCTAssertEqual(adapter.valueOverrides.values, [:])
    }
    
    func test_valueOverrides_givenSet_expectValueSet() {
        let given = [
            "id": "foo".data(using: .utf8)!
        ]
        
        adapter.valueOverrides = MockRemoteConfigAdapter.ValueOverrides(values: given)
        
        XCTAssertEqual(adapter.valueOverrides.values, given)
    }
    
    // If you want to use the mock adapter with UI tests, you more then likely need to set the initial app state using strings. Let's make sure you can do that.
    func test_valueOverrides_assertCanGetAndSetFromString() {
        // In your UI tests, you can set values.
        let givenOverride = [1, 2, 3]
        adapter.setValue(id: "id", value: givenOverride)
        
        // Then, when launching the app for UI testsing, you need to set launch environments using strings.
        let valueOverridesString: String = adapter.valueOverridesString
        
        // Then, when your app under test launches you will get the string from the launch environment. You then want to put that back into the app instance's mock adapter.
        let appInstanceMockAdapter = MockRemoteConfigAdapter(jsonEncoder: jsonAdapter.encoder, jsonDecoder: jsonAdapter.decoder)
        appInstanceMockAdapter.valueOverridesString = valueOverridesString
        
        XCTAssertEqual(appInstanceMockAdapter.valueOverrides.values, adapter.valueOverrides.values)
    }
    
}
