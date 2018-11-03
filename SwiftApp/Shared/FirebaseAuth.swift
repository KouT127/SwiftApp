//
//  FirebaseAuth.swift
//  SwiftApp
//
//  Created by kou on 2018/11/03.
//  Copyright © 2018 kou. All rights reserved.
//

import FirebaseAuth
import RxSwift
import RxCocoa

class FirebaseAuth {
    
    let auth = Auth.auth()
    static let shared = FirebaseAuth()
    
    public func signIn(withEmail email: String, password: String) -> Observable<AuthResult> {
        return auth.rx.signIn(withEmail: email, password: password)
            .map { .success(result: $0) }
            .catchError { Observable.just(.failed(error: $0))}
    }
}
