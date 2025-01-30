//
//  TokenKeychainManager.swift
//  TokenKeychainManager
//
//  Created by Артем Васин on 30.01.25.
//

import KeychainSwift
import SwiftUI

public final class TokenKeychainManager: ObservableObject {
    public static let shared = TokenKeychainManager()
    
    lazy private var keychain = KeychainSwift()
    
    private var accessTokenExpirationDate: Date?
    private var refreshTokenExpirationDate: Date?
    
    public var isAccessTokenExpired: Bool {
        guard let accessTokenExpirationDate else { return false }
        let isExpired = Date() > accessTokenExpirationDate
        return isExpired
    }
    
    public var isRefreshTokenExpired: Bool {
        guard let refreshTokenExpirationDate else { return false }
        let isExpired = Date() > refreshTokenExpirationDate
        return isExpired
    }
    
    @Published private(set) var validCredentials: Bool = false
    
    private init() {
        setExpirationDates()
        
        validateCredentials()
    }
    
    private func validateCredentials() {
        guard
            let accessToken = getAccessToken(),
            let refreshToken = getRefreshToken(),
            isAccessTokenExpired == false,
            isRefreshTokenExpired == false
        else {
            validCredentials = false
            return
        }
        
        validCredentials = true
    }
    
    public func setCredentials(accessToken: String, refreshToken: String) {
        keychain.set(accessToken, forKey: Constants.accessTokenKey)
        keychain.set(refreshToken, forKey: Constants.refreshTokenKey)
        
        setExpirationDates()
    }
    
    public func getAccessToken() -> String? {
        return keychain.get(Constants.accessTokenKey)
    }
    
    public func getRefreshToken() -> String? {
        return keychain.get(Constants.refreshTokenKey)
    }
    
    public func removeCredentials() {
        keychain.delete(Constants.accessTokenKey)
        keychain.delete(Constants.refreshTokenKey)
        
        setExpirationDates()
        
        validCredentials = false
    }
    
    private func setExpirationDates() {
        accessTokenExpirationDate = getTokenExpirationDate(getAccessToken())
        refreshTokenExpirationDate = getTokenExpirationDate(getRefreshToken())
    }
    
    private func getTokenExpirationDate(_ token: String?) -> Date? {
        guard let token else { return nil }
        
        let components = token.split(separator: ".")
        
        guard components.count == 3 else { return nil }
        
        let base64Data = Data(base64Encoded: String(components[1]), options: .ignoreUnknownCharacters)!
        
        let json = try! JSONSerialization.jsonObject(with: base64Data, options: []) as! [String:Any]
        let exp = json["exp"] as! Int
        let expDate = Date(timeIntervalSince1970: TimeInterval(exp))
        
        return expDate
    }
}
