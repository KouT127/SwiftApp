//
//  User.swift
//  SwiftApp
//
//  Created by kou on 2018/11/24.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation

struct User {
    let uid: String
    var name: String
    var profile: String?
    var url: URL?
    
    init(uid: String, name: String, profile: String?, url: URL? = nil) {
        self.uid = uid
        self.name = name
        self.profile = profile
        self.url = url
    }
}
