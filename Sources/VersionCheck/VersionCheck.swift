//
//  VersionCheck.swift
//  
//
//  Created by Emad Ghorbania on 11/11/2022.
//

import FirebaseRemoteConfig
import Helpers

public struct VersionCheck {
    var fetch: (
        _ latestVersionKeyFromFirebase: String,
        _ minSupportedVersionKeyFromFirebase: String,
        _ currentAppVersion: String,
        _ minimumFetchInterval: Double?
    ) async throws -> UpdateResult
    
    public static let live = Self { latestVersionKeyFromFirebase, minSupportedVersionKeyFromFirebase, currentAppVersion, minimumFetchInterval in
        try await VersionCheck.validateVersion(
            latestVersionKeyFromFirebase: latestVersionKeyFromFirebase,
            minSupportedVersionKeyFromFirebase: minSupportedVersionKeyFromFirebase,
            currentAppVersion: currentAppVersion,
            minimumFetchInterval: minimumFetchInterval)
    }
    /// You should initiate this struct by injecting variables to be able to start using ``VersionCheck`` and it Validates the latest version of the app!
    /// - Warning:You should configure FirebaseApp in your project by injecting info.plist to them before using this module
    /// - Example:
    /// ````
    ///    do {
    ///        let validation = try await VersionCheck.validateVersion(
    ///            latestVersionKeyFromFirebase: "iOSLatestVersionTest",
    ///            minSupportedVersionKeyFromFirebase: "iOSMinSupportedVersionTest",
    ///            currentAppVersion: Bundle.main.versionString
    ///        )
    ///        switch validation {
    ///        case .mustUpdate :
    ///            mustUpdateAlert = true
    ///        case .updateExist :
    ///            updateAlert = true
    ///        case .noUpdate:
    ///            No Update
    ///        }
    ///    } catch {
    ///        Send error to crashlytics
    ///    }
    ///````
    /// - Parameters:
    ///   - latestVersionKeyFromFirebase: The Firebase Remote Config key for latest app version
    ///   - minSupportedVersionKeyFromFirebase: The Firebase Remote Config key for minimun supported app version
    ///   - currentAppVersion: Current version of the app that you can get by fetching "CFBundleShortVersionString" from info.plist
    ///   - minimumFetchInterval: Indicates the default value in seconds to set for the minimum interval that needs to elapse
    /// before a fetch request can again be made to the Remote Config backend. After a fetch request to
    /// the backend has succeeded, no additional fetch requests to the backend will be allowed until the
    /// minimum fetch interval expires. Note that you can override this default on a per-fetch request
    /// basis using `RemoteConfig.fetch(withExpirationDuration:)`. For example, setting
    /// the expiration duration to 0 in the fetch request will override the `minimumFetchInterval` and
    /// allow the request to proceed. For more information, see [Firebase Doccumentation]( https://firebase.google.com/docs/remote-config/get-started?platform=ios#throttling)
    ///   - defaultValues: Sets config defaults for parameter keys and values in the default namespace config by using A dictionary mapping a String * key to a Any * value.
    /// - Returns: ``VersionCheck/UpdateResult``
    /// - Throws: ``Helpers/CustomError``
    public static func validateVersion(
        latestVersionKeyFromFirebase: String,
        minSupportedVersionKeyFromFirebase: String,
        currentAppVersion: String,
        minimumFetchInterval: Double? = nil
    ) async throws -> UpdateResult {
        let remoteConfig = RemoteConfig.remoteConfig()
        RemoteConfigHelper.customizeSettingsIfNeeded(
            remoteConfig: remoteConfig,
            minimumFetchInterval: minimumFetchInterval)
        let fetchedRemoteConfig = await RemoteConfigHelper.fetchRemoteConfig(remoteConfig: remoteConfig)
        let activatedRemoteConfig = try await RemoteConfigHelper.activeRemoteConfig(remoteConfig: fetchedRemoteConfig.get())
        let latestVersion = try RemoteConfigHelper.getStringValueForKey(remoteConfig: activatedRemoteConfig.get(), key: latestVersionKeyFromFirebase)
        let minSupportedVersion = try RemoteConfigHelper.getStringValueForKey(remoteConfig: activatedRemoteConfig.get(), key: minSupportedVersionKeyFromFirebase)
        return  VersionCheck.isThereAnyUpdate(
            latestVersionValue: latestVersion,
            minSupportedVersionValue: minSupportedVersion,
            currentAppVersion: currentAppVersion
        )
    }
}

extension VersionCheck {
    static func isThereAnyUpdate(
        latestVersionValue: String,
        minSupportedVersionValue: String,
        currentAppVersion: String
    ) -> UpdateResult {
        if currentAppVersion.versionCompare(latestVersionValue) == .orderedAscending {
            if currentAppVersion.versionCompare(minSupportedVersionValue) == .orderedAscending {
                return .mustUpdate
            } else {
                return .updateExist
            }
        } else {
            return .noUpdate
        }
    }
}
