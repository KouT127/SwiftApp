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
    
    func signIn(withEmail email: String, password: String) -> Observable<AuthResult> {
        return auth.rx.signIn(withEmail: email, password: password)
            .map { .succeed(result: $0) }
            .catchError { Observable.just(.failed(error: $0))}
    }
    
    func errorMessage(result: AuthResult) -> String{
        switch result {
        case .failed( let error ):
            let firebaseError = error as NSError
            if firebaseError.code == 17009 || firebaseError.code == 17011 {
                return "メールアドレスまたはパスワードが間違っています"
            }
            if firebaseError.code == 17020 {
                return "ネットワークエラー"
            }
        default:
            break
        }
        return "不明なエラー"
    }
    
    func createAuthUser(new: AuthDataResult) -> AuthUser{
        let user = AuthUser()
        user.providerId = new.user.providerID
        user.uid = new.user.uid
        user.displayName = new.user.displayName
        user.email = new.user.email
        return user
    }
}
