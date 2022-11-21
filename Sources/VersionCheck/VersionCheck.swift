//
//  VersionCheck.swift
//  
//
//  Created by Emad Ghorbania on 11/11/2022.
//

import FirebaseRemoteConfig


public struct VersionCheck {
    fileprivate var remoteConfig: RemoteConfig
    /// You should initiate this struct by injecting variables to be able to start using ``VersionCheck`` and it Validates the curent version of the app!
    /// - Warning:You should configure FirebaseApp in your project by injecting info.plist to them before using this module
    /// - Example:
    /// ````
    ///    do {
    ///        let validation = try await VersionCheck.validateVersion(
    ///        currentVersionKey: "iOSCurrentVersionTest",
    ///        minSupportedVersionKey: "iOSMinSupportedVersionTest",
    ///        currentAppVersion: Bundle.main.versionString
    ///    )
    ///    switch validation {
    ///        case .mustUpdate :
    ///            mustUpdateAlert = true
    ///        case .updateExist :
    ///            updateAlert = true
    ///        case .noUpdate:
    ///         No Update
    ///        }
    ///    } catch {
    ///        Send error to crashlytics
    ///    }
    ///````
    /// - Parameters:
    ///   - currentVersionKey: The key has been stored in Firebase Remote Config
    ///   - minSupportedVersionKey: The key has been stored in Firebase Remote Config
    ///   - currentAppVersion: Curent version of the app that you can get by fetching "CFBundleShortVersionString" from info.plist
    ///   - defaultValues:Sets config defaults for parameter keys and values in the default namespace config by using A dictionary mapping a String * key to a Any * value.
    ///   - minimumFetchInterval:Indicates the default value in seconds to set for the minimum interval that needs to elapse
    /// before a fetch request can again be made to the Remote Config backend. After a fetch request to
    /// the backend has succeeded, no additional fetch requests to the backend will be allowed until the
    /// minimum fetch interval expires. Note that you can override this default on a per-fetch request
    /// basis using `RemoteConfig.fetch(withExpirationDuration:)`. For example, setting
    /// the expiration duration to 0 in the fetch request will override the `minimumFetchInterval` and
    /// allow the request to proceed.
    /// - Returns: ``VersionCheck/UpdateResult``
    /// - Throws: ``VersionCheck/CustomError``
    public static func validateVersion(currentVersionKey: String,
                                minSupportedVersionKey: String,
                                currentAppVersion: String,
                                minimumFetchInterval: Double? = nil,
                                defaultValues: [String: Any?]? = nil) async throws -> UpdateResult {
        let remoteConfig = RemoteConfig.remoteConfig()
        VersionCheck.customizeSettings(remoteConfig: remoteConfig,
                                       minimumFetchInterval: minimumFetchInterval,
                                       defaultValues: defaultValues)
        let fetchedRemoteConfig = await VersionCheck.fetchRemoteConfig(remoteConfig: remoteConfig)
        let activatedRemoteConfig = try await VersionCheck.activeRemoteConfig(remoteConfig: fetchedRemoteConfig.get())
        let currentValidVersion = try VersionCheck.getStringValueForeKey(remoteConfig: activatedRemoteConfig.get(), key: currentVersionKey)
        let minSupportedVersion = try VersionCheck.getStringValueForeKey(remoteConfig: activatedRemoteConfig.get(), key: minSupportedVersionKey)
        return  VersionCheck.isThereAnyUpdate(currentValidVersionValue: currentValidVersion,
                                              minSupportedVersionValue: minSupportedVersion,
                                              currentAppVersion: currentAppVersion)
    }
}

extension VersionCheck {
    private static func customizeSettings(remoteConfig: RemoteConfig,
                                          minimumFetchInterval: Double?,
                                          defaultValues: [String: Any?]?) {
        if let minimumFetchInterval = minimumFetchInterval {
            let settings = RemoteConfigSettings()
            settings.minimumFetchInterval = minimumFetchInterval
            remoteConfig.configSettings = settings
        }
        if let defaultValues = defaultValues as? [String: NSObject] {
            remoteConfig.setDefaults(defaultValues)
        }
    }
    static func getStringValueForeKey(remoteConfig: RemoteConfig, key: String) throws -> String {
        guard let value = remoteConfig.configValue(forKey: "\(key)").stringValue
        else { throw CustomError.noValueFound(key: key)}
        return value
    }
    static func isThereAnyUpdate(currentValidVersionValue: String,
                                 minSupportedVersionValue: String,
                                 currentAppVersion: String) -> UpdateResult {
        if currentAppVersion.versionCompare(currentValidVersionValue) == .orderedAscending {
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
