//
//  PrintLoggingRemoteConfigAdapterPlugin.swift
//  Boquila
//
//  Created by Levi Bostian on 6/24/20.
//

import Foundation

public class PrintLoggingRemoteConfigAdapterPlugin: RemoteConfigAdapterPlugin {
    
    let prefix: String
    let dateFormat: String
    
    public init(prefix: String = "[BOQUILA]", dateFormat: String = "yy-MM-dd h:mm:ss.SSS") {
        self.prefix = prefix
        self.dateFormat = dateFormat
    }
    
    public func manipulateStringValue(_ stringValue: String) -> String {
        log("String value from remote config service: \(stringValue)")
        
        return stringValue
    }
    public func activateBegin() {
        log("Activate remote config")
    }
    public func refreshBegin() {
        log("Remote config refresh begin...")
    }
    public func refreshEnd(result: Result<Void, Error>) {
        switch result {
        case .success:
            log("Remote config refresh success!")
        case .failure(let error):
            log("Remote config refresh error. Description: \(error.localizedDescription)")
        }
    }
    
    private func log(_ message: String) {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = self.dateFormat
        let dateString = formatter.string(from: now)
        
        print("\(dateString) \(prefix) \(message)")
    }
}
