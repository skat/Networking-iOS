//
//  File.swift
//  
//
//  Created by Emad Ghorbania on 11/11/2022.
//

import Foundation
extension VersionCheck {
     public enum UpdateResult: Equatable {
        case noUpdate
        case updateExist
        case mustUpdate
    }
}
