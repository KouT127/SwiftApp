//
//  FirebaseAuth+Rx.swift
//  SwiftApp
//
//  Created by kou on 2018/11/03.
//  Copyright © 2018 kou. All rights reserved.
//

import RxSwift
import FirebaseAuth

extension Reactive where Base: Auth {

    public func signIn(withEmail email: String, password: String) -> Observable<AuthDataResult> {
        return Observable.create { observer in
            self.base.signIn(withEmail: email, password: password) { auth, error in
                if let error = error {
                    observer.onError(error)
                } else if let auth = auth {
                    observer.onNext(auth)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    public func createUser(withEmail email: String, password: String) -> Observable<AuthDataResult> {
        return Observable.create { observer in
            self.base.createUser(withEmail: email, password: password) { auth, error in
                if let error = error {
                    observer.onError(error)
                } else if let auth = auth {
                    observer.onNext(auth)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

}
