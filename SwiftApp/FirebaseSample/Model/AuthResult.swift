//
//  AuthResult.swift
//  SwiftApp
//
//  Created by kou on 2018/11/04.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation
import FirebaseAuth

enum AuthResult {
    case succeed(result: AuthDataResult)
    case failed(error: Error)
}
