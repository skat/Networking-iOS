//
//  File.swift
//  
//
//  Created by Emad Ghorbania on 22/09/2022.
//

import Foundation
public extension AuthenticationHandler {
    struct UserModel: Codable {
        public var name: String?
        public var givenName: String?
        public var familyName: String?
        public var preferredUsername: String?
        public var email: String?
    }
}
