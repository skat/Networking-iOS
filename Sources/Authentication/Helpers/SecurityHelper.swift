//
//  File.swift
//  
//
//  Created by Emad Ghorbaninia on 21/09/2022.
//

import Foundation
import Security

private let SecClass = kSecClass as String
private let SecAttrService = kSecAttrService as String
private let SecAttrGeneric = kSecAttrGeneric as String
private let SecAttrAccount = kSecAttrAccount as String
private let SecMatchLimit = kSecMatchLimit as String
private let SecReturnData = kSecReturnData as String
private let SecValueData = kSecValueData as String
private let SecAttrAccessible = kSecAttrAccessible as String
extension AuthenticationHandler {
    final class SecurityHelper {
        static func search(matching identifier: String) -> Data? {
            var dictionary = setupSearchDirectory(for: identifier)
            
            // Limit search results to one
            dictionary[SecMatchLimit] = kSecMatchLimitOne
            
            // Specify we want NSData/CFData returned
            dictionary[SecReturnData] = kCFBooleanTrue
            
            var result: AnyObject?
            let status = SecItemCopyMatching(dictionary as CFDictionary, &result)
            
            return status == noErr ? result as? Data : nil
        }
        
        static func string(matching identifier: String) -> String? {
            guard let data = self.search(matching: identifier) else {
                return nil
            }
            
            return String(data: data, encoding: .utf8)
        }
        
        @discardableResult
        static func create(value: String, forIdentifier identifier: String) -> Bool {
            var dictionary = setupSearchDirectory(for: identifier)
            
            let encodedValue = value.data(using: .utf8)
            dictionary[SecValueData] = encodedValue
            
            // Protect the keychain entry so its only valid when the device is unlocked
            dictionary[SecAttrAccessible] = kSecAttrAccessibleWhenUnlocked
            
            let status = SecItemAdd(dictionary as CFDictionary, nil)
            switch status {
            case errSecSuccess:
                return true
            case errSecDuplicateItem:
                return self.update(value: value, forIdentifier: identifier)
            default:
                return false
            }
        }
        
        @discardableResult
        static func update(value: String, forIdentifier identifier: String) -> Bool {
            let dictionary = setupSearchDirectory(for: identifier)
            
            let encodedValue = value.data(using: .utf8)
            let update = [SecValueData: encodedValue]
            
            let status = SecItemUpdate(dictionary as CFDictionary, update as CFDictionary)
            
            return status == errSecSuccess
        }
        
        @discardableResult
        static func remove(identifier: String) -> Bool {
            let dictionary = setupSearchDirectory(for: identifier)
            
            let status = SecItemDelete(dictionary as CFDictionary)
            return status == errSecSuccess
        }
        
        private static func setupSearchDirectory(for identifier: String) -> [String: Any] {
            // We are looking for passwords
            var searchDictionary: [String: Any] = [SecClass: kSecClassGenericPassword]
            
            // Identify our access
            searchDictionary[SecAttrService] = Bundle.main.bundleIdentifier
            
            // Uniquely identify the account who will be accessing the keychain
            let encodedIdentifier = identifier.data(using: .utf8)
            searchDictionary[SecAttrGeneric] = encodedIdentifier
            searchDictionary[SecAttrAccount] = encodedIdentifier
            
            return searchDictionary
        }
    }
}
