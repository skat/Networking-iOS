//
//  VersionCheck.swift
//  
//
//  Created by Emad Ghorbania on 11/11/2022.
//

import FirebaseRemoteConfig


public struct VersionCheck {
    fileprivate var remoteConfig: RemoteConfig
    var currentVersionKey: String
    var minSupportedVersionKey: String
    var currentAppVersion: String
    var minimumFetchInterval: Double?
  
    public init(currentVersionKey: String,
                minSupportedVersionKey: String,
                currentAppVersion: String,
                minimumFetchInterval: Double? = nil) {
        self.currentVersionKey = currentVersionKey
        self.minSupportedVersionKey = minSupportedVersionKey
        self.currentAppVersion = currentAppVersion
        self.minimumFetchInterval = minimumFetchInterval
        self.remoteConfig = RemoteConfig.remoteConfig()
        customizeSettings()
    }
    
    public func validateVersion() async throws -> UpdateResult {
        let fetchedRemoteConfig = await fetchRemoteConfig(remoteConfig: remoteConfig)
        let activatedRemoteConfig = try await activeRemoteConfig(remoteConfig: fetchedRemoteConfig.get())
        return try await isThereAnyUpdate(remoteConfig: activatedRemoteConfig.get())
    }
    private func customizeSettings() {
        if let minimumFetchInterval = minimumFetchInterval {
            let settings = RemoteConfigSettings()
            settings.minimumFetchInterval = minimumFetchInterval
            remoteConfig.configSettings = settings
        }
    }
}
