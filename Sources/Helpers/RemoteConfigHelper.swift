//
//  File.swift
//  
//
//  Created by Emad Ghorbania on 11/11/2022.
//

import FirebaseRemoteConfig

public struct RemoteConfigHelper {
    public static func fetchRemoteConfig(remoteConfig: RemoteConfig) async -> Result<RemoteConfig, CustomError> {
        return await withCheckedContinuation { continuation in
            remoteConfig.fetch { (status, error) -> Void in
                switch status {
                case .success:
                    continuation.resume(returning: .success(remoteConfig))
                case .failure, .noFetchYet, .throttled:
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
    public static func activeRemoteConfig(remoteConfig: RemoteConfig) async -> Result<RemoteConfig, CustomError> {
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
    public static func getModeledValueForKey<DataType: Codable>(remoteConfig: RemoteConfig,
                                                         key: String,
                                                         expectationModel: DataType.Type) throws -> DataType {
        let data = remoteConfig.configValue(forKey: "\(key)").dataValue
        return try JSONDecoder().decode(DataType.self, from: data)
    }

    public static func getBoolValueForKey(remoteConfig: RemoteConfig, key: String) -> Bool {
        return remoteConfig.configValue(forKey: "\(key)").boolValue
    }
    
    public static func getStringValueForKey(remoteConfig: RemoteConfig, key: String) throws -> String {
        guard let value = remoteConfig.configValue(forKey: "\(key)").stringValue
        else { throw CustomError.noValueFound(key: key)}
        return value
    }
    
    public static func customizeSettingsIfNeeded(remoteConfig: RemoteConfig,
                                          minimumFetchInterval: Double?) {
        if let minimumFetchInterval = minimumFetchInterval {
            let settings = RemoteConfigSettings()
            settings.minimumFetchInterval = minimumFetchInterval
            remoteConfig.configSettings = settings
        }
    }
}
