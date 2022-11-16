//
//  File.swift
//  
//
//  Created by Emad Ghorbania on 22/09/2022.
//

import Foundation
public extension AuthenticationHandler {
    /// It's default UserModel, you can of course extend or change if if you know you get more
    struct UserModel: Codable {
        public var name: String?
        public var givenName: String?
        public var familyName: String?
        public var preferredUsername: String?
        public var email: String?
    }
}
