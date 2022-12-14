//
//  File.swift
//  
//
//  Created by Emad Ghorbania on 11/11/2022.
//

import Foundation
public extension VersionCheck {
    enum CustomError: Error, LocalizedError, Equatable {
        case noValueFound(key: String)
        case invalidError
        case validError(error: String)
    }
}
