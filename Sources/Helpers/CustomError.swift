//
//  File.swift
//  
//
//  Created by Emad Ghorbania on 14/12/2022.
//

import Foundation
public enum CustomError: Error, LocalizedError, Equatable {
    case noValueFound(key: String)
    case invalidError
    case validError(error: String)
}
