//
//  File.swift
//  
//
//  Created by Emad Ghorbania on 11/11/2022.
//

import Foundation
import FirebaseRemoteConfig
extension VersionCheck {
    func fetchRemoteConfig(remoteConfig: RemoteConfig) async -> Result<RemoteConfig, CustomError> {
            return await withCheckedContinuation { continuation in
                remoteConfig.fetch { (status, error) -> Void in
                    switch status {
                    case .success:
                        continuation.resume(returning: .success(remoteConfig))
                    case .failure, .noFetchYet, .throttled :
                        if let error = error {
                            continuation.resume(returning: .failure(.validError(error: error.localizedDescription)))
                        } else {
                            continuation.resume(returning: .failure(CustomError.invalidError))
                        }
                    @unknown default:
                        continuation.resume(returning: .failure(.invalidError))
                    }
                }
            }
        }
    func activeRemoteConfig(remoteConfig: RemoteConfig) async -> Result<RemoteConfig, CustomError> {
        return await withCheckedContinuation { continuation in
            remoteConfig.activate { changed, error in
                if let error = error {
                    continuation.resume(returning: .failure(.validError(error: error.localizedDescription)))
                } else {
                    continuation.resume(returning: .success(remoteConfig))
                }
            }
        }
    }
    func isThereAnyUpdate(remoteConfig: RemoteConfig) async throws -> UpdateResult {
        guard let currentValidVersion = remoteConfig.configValue(forKey: "\(currentVersionKey)").stringValue
        else { throw CustomError.noValueFound(key: currentVersionKey)}
        
        guard let minSupportedVersion = remoteConfig.configValue(forKey: "\(minSupportedVersionKey)").stringValue
        else { throw CustomError.noValueFound(key: minSupportedVersionKey)}
        
        if currentAppVersion.versionCompare(currentValidVersion) == .orderedAscending {
            if currentAppVersion.versionCompare(minSupportedVersion) == .orderedAscending {
                return .mustUpdate
            } else {
                return .updateExist
            }
        } else {
            return .noUpdate
        }
    }
}
