//
//  App.swift
//  Crypt
//
//  Created by Mac Owner on 30/10/2015.
//  Copyright © 2015 Crypt transfer. All rights reserved.
//

import Foundation

import UIKit
import SimpleKeychain
import Lock
import LockFacebook
import Alamofire
import JWTDecode

struct App {
    
    static var sharedInstance = App()
    
    static let baseURL = "http://localhost:9292/api/v1"
    static let braintreeURL = "com.crypttransfer.crypt.braintree"
    static let stripePKey = "pk_test_6pRNASCoBOKtIshFeQd4XMUh"
    static let optimizelyKey = "AANPELcB09HfBbh7pLsbm9tXQbxjBV7O~5679860087"
    static let appVersion = "iOS \(NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] ?? "unknown") (\(NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] ?? "unknown"))"
    
    let keychain: A0SimpleKeychain
    let lock: A0Lock
    
    var profile: A0UserProfile?{
        get{
            var profile: A0UserProfile? = nil
            if let data = keychain.dataForKey("profile"){
                profile = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? A0UserProfile
            }
            return profile
        }
        set{
            if let profile = newValue{
                keychain.setData(NSKeyedArchiver.archivedDataWithRootObject(profile), forKey: "profile")
            }
            else{
                keychain.setNilValueForKey("profile")
            }
        }
    }
    
    private init() {
        self.keychain = A0SimpleKeychain(service: "Auth0")
        self.lock = A0Lock()
        let obf = Obfuscator.initForSwift()
        let ApiKey: [UInt8] = [ 0x5C, 0x5C, 0x75, 0x51, 0x7D, 0x40, 0x31, 0x5D, 0x7B, 0x13, 0xB, 0x28, 0x58, 0x6, 0x55, 0x65, 0x58, 0x76, 0x5D, 0x7D, 0x2A, 0x2D, 0x3C, 0xC, 0x3, 0x00 ]
        let ApiSecret: [UInt8] = [ 0x71, 0x76, 0x62, 0x24, 0x44, 0x41, 0x22, 0x77, 0x61, 0x7, 0x34, 0x1, 0x43, 0x40, 0x68, 0x7A, 0x5F, 0x7C, 0x45, 0x68, 0x51, 0xC, 0x3C, 0x27, 0x40, 0x17, 0x47, 0x8, 0x66, 0x30, 0x66, 0x72, 0x29, 0x78, 0x60, 0x9, 0x44, 0x3, 0x60, 0xF, 0x7F, 0x62, 0x64, 0xC, 0x7A, 0x63, 0x17, 0x5D, 0x75, 0x20, 0x00 ]
        let facebook = A0FacebookAuthenticator.newAuthenticatorWithDefaultPermissions()
        let twitter = A0TwitterAuthenticator.newAuthenticatorWithKey(obf.reveal(ApiKey), andSecret: obf.reveal(ApiSecret))
        let google = A0GoogleAuthenticator.newAuthenticator()
        self.lock.registerAuthenticators([facebook,twitter,google])
    }
    func apiRequest(
        method: Alamofire.Method,
        _ endpoint: URLStringConvertible,
          parameters: [String: AnyObject]? = nil,
          encoding: ParameterEncoding = .URL,
          headers: [String: String] = [:],
          completionHandler: Response<AnyObject, NSError> -> Void){
            let URLString = App.baseURL + endpoint.URLString
            var newHeaders = headers
            newHeaders["Device ID"] = "\(UIDevice.currentDevice().identifierForVendor?.UUIDString ?? "unknown")"
            newHeaders["App Version"] = App.appVersion
            if let idToken = keychain.stringForKey("id_token"), let jwt = try? JWTDecode.decode(idToken) {
                if jwt.expired, let refreshToken = keychain.stringForKey("refresh_token") {
                    
                    let success = {(token:A0Token!) -> () in
                        self.keychain.setString(token.idToken, forKey: "id_token")
                        newHeaders["Authorization"] = "Bearer \(token.idToken)"
                        Alamofire.request(method, URLString, parameters: parameters, encoding: encoding, headers: newHeaders).responseJSON(completionHandler: completionHandler)
                    }
                    let failure = {(error:NSError!) -> () in
                        self.keychain.clearAll()
                        completionHandler(Response(request: nil, response: nil, data: nil, result: Result.Failure(error)))
                    }
                    let client = lock.apiClient()
                    client.fetchNewIdTokenWithRefreshToken(refreshToken, parameters: nil, success: success, failure: failure)
                }else{
                    newHeaders["Authorization"] = "Bearer \(idToken)"
                    Alamofire.request(method, URLString, parameters: parameters, encoding: encoding, headers: newHeaders).responseJSON(completionHandler: completionHandler)
                }
                
            }else{
                let error = NSError(domain: "no token", code: 999, userInfo: ["error":"no token"])
                completionHandler(Response(request: nil, response: nil, data: nil, result: Result.Failure(error)))
        }
    }
}


