//
//  AuthDataResult.swift
//  SwiftApp
//
//  Created by kou on 2018/11/04.
//  Copyright © 2018 kou. All rights reserved.
//

import FirebaseAuth
import Realm
import RealmSwift

class AuthUser: Object {
    @objc dynamic var providerId: String = ""
    @objc dynamic var uid: String = ""
    @objc dynamic var displayName: String? = ""
    @objc dynamic var email: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case providerID, uid, displayName, email
    }
}