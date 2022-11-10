//
//  File.swift
//  
//
//  Created by Emad Ghorbania on 21/09/2022.
//

import Foundation
import CommonCrypto

extension AuthenticationHandler.Configuration {
    /// Generating a code verifier for PKCE
    static func generateCodeVerifier() -> String? {
        var buffer = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
        let codeVerifier = Data(buffer).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        return codeVerifier
    }
    
    /// Generating a code challenge for PKCE
    static func generateCodeChallenge(codeVerifier: String?) -> String? {
        guard let verifier = codeVerifier, let data = verifier.data(using: .utf8) else { return nil }
        
        var buffer = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &buffer)
        }
        let hash = Data(buffer)
        
        let challenge = hash.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        return challenge
    }
}
