//
//  GlobalState.swift
//  Crypt
//
//  Created by Mac Owner on 30/10/2015.
//  Copyright © 2015 Crypt transfer. All rights reserved.
//

import Foundation

import UIKit
import Lock
import LockFacebook

struct GlobalState {
    
    static let sharedInstance = GlobalState()
    
    let lock: A0Lock
    
    init() {
        self.lock = A0Lock()
        let facebook = A0FacebookAuthenticator.newAuthenticatorWithDefaultPermissions()
        self.lock.registerAuthenticators([facebook])
    }
}
