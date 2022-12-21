//
//  File.swift
//  
//
//  Created by Emad Ghorbania on 14/12/2022.
//

import Foundation
import FirebaseRemoteConfig
import Helpers

struct Maintenance {
    var fetch: (
        _ minimumFetchInterval: Double?,
        _ bannerKey: String,
        _ fullscreenKey: String,
        _ bannerDetailsKey: String,
        _ fullscreenDetailsKey: String
    ) async throws -> (StatusType, Detail)?
    
    public static let live = Self { minimumFetchInterval, bannerKey, fullscreenKey, bannerDetailsKey, fullscreenDetailsKey in
        try await Maintenance.fetchFromFirebaseRemoteConfige(
            minimumFetchInterval: minimumFetchInterval,
            bannerKey: bannerKey,
            fullscreenKey: fullscreenKey,
            bannerDetailsKey: bannerDetailsKey,
            fullscreenDetailsKey: fullscreenDetailsKey)
    }
    /// You should initiate this struct by injecting variables to be able to start using ``Maintenance`` and it Validates the latest version of the app!
    /// - Warning:You should configure FirebaseApp in your project by injecting info.plist to them before using this module
    /// - Example:
    /// ````
    /// do {
    ///     let maintenance = try await Maintenance.fetchFromFirebaseRemoteConfige(bannerKey: "Test_Banner_iOS",
    ///                                                                            fullscreenKey: "Test_Fullscreen_iOS",
    ///                                                                            bannerDetailsKey: "Test_BannerDetail_iOS",
    ///                                                                            fullscreenDetailsKey: "Test_FullscreenDetail_iOS")
    ///     switch maintenance?.0 {
    ///     case .banner:
    ///         print(maintenance?.1)
    ///     case .fullscreen
    ///         print(maintenance?.1)
    ///     case .none:
    ///         No Maintenance
    ///     }}
    /// } catch {
    ///     Send error to crashlytics
    /// }
    ///````
    /// - Parameters:
    ///   - bannerKey: The Firebase Remote Config key for banner
    ///   - fullscreenKey: The Firebase Remote Config key for fullscreen
    ///   - bannerDetailsKey: The Firebase Remote Config key for bannerDetails
    ///   - fullscreenDetailsKey: The Firebase Remote Config key for fullscreenDetails
    ///   - minimumFetchInterval: Indicates the default value in seconds to set for the minimum interval that needs to elapse
    /// before a fetch request can again be made to the Remote Config backend. After a fetch request to
    /// the backend has succeeded, no additional fetch requests to the backend will be allowed until the
    /// minimum fetch interval expires. Note that you can override this default on a per-fetch request
    /// basis using `RemoteConfig.fetch(withExpirationDuration:)`. For example, setting
    /// the expiration duration to 0 in the fetch request will override the `minimumFetchInterval` and
    /// allow the request to proceed. For more information, see [Firebase Doccumentation]( https://firebase.google.com/docs/remote-config/get-started?platform=ios#throttling)
    ///   - defaultValues: Sets config defaults for parameter keys and values in the default namespace config by using A dictionary mapping a String * key to a Any * value.
    /// - Returns: ``Maintenance/StatusType`` and ``Maintenance/Detail``
    /// - Throws: ``Helpers/CustomError``
    public static func fetchFromFirebaseRemoteConfige(
        minimumFetchInterval: Double? = nil,
        bannerKey: String,
        fullscreenKey: String,
        bannerDetailsKey: String,
        fullscreenDetailsKey: String
    ) async throws -> (StatusType, Detail)? {

        let remoteConfig = RemoteConfig.remoteConfig()

        RemoteConfigHelper.customizeSettingsIfNeeded(
            remoteConfig: remoteConfig,
            minimumFetchInterval: minimumFetchInterval
        )
        
        let fetchedRemoteConfig = await RemoteConfigHelper.fetchRemoteConfig(remoteConfig: remoteConfig)
        
        let activatedRemoteConfig = try await RemoteConfigHelper.activeRemoteConfig(remoteConfig: fetchedRemoteConfig.get())
        
        let banner = try RemoteConfigHelper.getBoolValueForKey(
            remoteConfig: activatedRemoteConfig.get(),
            key: bannerKey
        )
        
        let fullscreen = try RemoteConfigHelper.getBoolValueForKey(
            remoteConfig: activatedRemoteConfig.get(),
            key: fullscreenKey
        )
        
        let bannerDetail = try RemoteConfigHelper.getModeledValueForKey(
            remoteConfig: activatedRemoteConfig.get(),
            key: bannerDetailsKey,
            expectationModel: Detail.self
        )
        
        let fullscreenDetail = try RemoteConfigHelper.getModeledValueForKey(
            remoteConfig: activatedRemoteConfig.get(),
            key: fullscreenDetailsKey,
            expectationModel: Detail.self
        )
        
        return isThereAnyMaintenance(
            fullscreen: fullscreen,
            banner: banner,
            fullscreenDetail: fullscreenDetail,
            bannerDetail: bannerDetail
        )
        
        
    }
    
    static func isThereAnyMaintenance(
        fullscreen: Bool,
        banner: Bool,
        fullscreenDetail: Detail,
        bannerDetail: Detail
    ) -> (StatusType, Detail)? {
        
        if fullscreen {
            return (.fullscreen, fullscreenDetail)
        }
        
        if banner {
            return (.banner, bannerDetail)
        }
        
        return nil
    }

}


