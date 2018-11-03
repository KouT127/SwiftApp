//
//  FirebaseAuth.swift
//  SwiftApp
//
//  Created by kou on 2018/11/03.
//  Copyright © 2018 kou. All rights reserved.
//

import FirebaseAuth
import RxSwift

class FirebaseAuth {
    
    let auth = Auth.auth()
    
    public func signIn(withEmail email: String, password: String) -> Observable<AuthDataResult> {
        //RxFirebaseを入れた場合の、想定としてこの様な形とした。
        return auth.rx.signIn(withEmail: email, password: password)
    }
}
