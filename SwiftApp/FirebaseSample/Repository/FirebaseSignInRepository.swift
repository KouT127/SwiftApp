//
//  FirebaseSignInRepository.swift
//  SwiftApp
//
//  Created by kou on 2018/11/04.
//  Copyright © 2018 kou. All rights reserved.
//

import FirebaseAuth
import RxSwift
import RxCocoa

class FirebaseSignInRepository {
    
    private let auth = Auth.auth()
    
    public func signIn(withEmail email: String, password: String) -> Observable<AuthResult> {
        return auth.rx.signIn(withEmail: email, password: password)
            .map { .succeed(result: $0) }
            .catchError { Observable.just(.failed(error: $0))}
    }
}
