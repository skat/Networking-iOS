//
//  File.swift
//  
//
//  Created by Emad Ghorbania on 21/09/2022.
//

import Foundation
public extension AuthenticationHandler {
    
    /// Configuration of ``AuthenticationHandler`` to be able to work with
    /// - Example:
    /// ````
    /// AuthenticationHandler.Configuration
    /// (
    ///     baseURL: "https://billetautomat-keycloak-dcs-plugin-master-test.ocpt.ccta.dk",
    ///     clientID: "digital-logbog",
    ///     authorizePath: "/auth/realms/azure-uat/protocol/openid-connect/auth",
    ///     accessTokenPath: "/auth/realms/azure-uat/protocol/openid-connect/token",
    ///     userInfoPath: "/auth/realms/azure-uat/protocol/openid-connect/userinfo",
    ///     callBackURL: "dk.ufst.toldkontrol.debug:/",
    ///     callbackURLScheme: "dk.ufst.toldkontrol.debug",
    ///     scopes: ["openid", "digital-logbog"]
    ///)
    /// ````
    struct Configuration {
        /// It's Configuration property to be used in all the logics in ``AuthenticationHandler``
        /// - Parameters:
        ///   - baseURL: BaseURL for OAuth2
        ///   - clientID: Needed for Getting the AuthorizationCode
        ///   - authorizePath: Path for Authorization Api
        ///   - accessTokenPath: Path for Token Api
        ///   - userInfoPath: Path for UserInfo Api
        ///   - callBackURL: Eider custom registered URL or Bundle ID
        ///   - callbackURLScheme: Eider custom registered Scheme or Bundle ID
        ///   - scopes: Array of scopes for using OAuth2
        ///
        ///   - Example:
        /// ````
        /// AuthenticationHandler.Configuration
        /// (
        ///     baseURL: "https://billetautomat-keycloak-dcs-plugin-master-test.ocpt.ccta.dk",
        ///     clientID: "digital-logbog",
        ///     authorizePath: "/auth/realms/azure-uat/protocol/openid-connect/auth",
        ///     accessTokenPath: "/auth/realms/azure-uat/protocol/openid-connect/token",
        ///     userInfoPath: "/auth/realms/azure-uat/protocol/openid-connect/userinfo",
        ///     callBackURL: "dk.ufst.toldkontrol.debug:/",
        ///     callbackURLScheme: "dk.ufst.toldkontrol.debug",
        ///     scopes: ["openid", "digital-logbog"]
        ///)
        /// ````
        public init (
            baseURL: String,
            clientID: String,
            authorizePath: String,
            accessTokenPath: String,
            userInfoPath: String,
            callBackURL: String,
            callbackURLScheme: String,
            scopes: [String]
        ) {
            self.baseURL = baseURL
            self.clientID = clientID
            self.authorizePath = authorizePath
            self.accessTokenPath = accessTokenPath
            self.userInfoPath = userInfoPath
            self.callBackURL = callBackURL
            self.callbackURLScheme = callbackURLScheme
            self.scopes = scopes
            
            self.codeVerifier = Configuration.generateCodeVerifier()
            self.codeChallenge = Configuration.generateCodeChallenge(codeVerifier: self.codeVerifier)
        }
        
        let codeVerifier: String?
        let codeChallenge: String?
        let baseURL: String //= "https://billetautomat-keycloak-dcs-plugin-master-test.ocpt.ccta.dk"
        let clientID: String //= "digital-logbog"
        let authorizePath: String //= "/auth/realms/azure-uat/protocol/openid-connect/auth"
        let accessTokenPath: String //= "/auth/realms/azure-uat/protocol/openid-connect/token"
        let userInfoPath: String //="/auth/realms/dcs63/protocol/openid-connect/userinfo"
        let callBackURL: String //= "dk.ufst.toldkontrol.debug:/"
        let callbackURLScheme: String // = "dk.ufst.toldkontrol.debug"
        let scopes: [String] //= ["openid", "digital-logbog"]
    }
}
