//
//  FirebaseSignInRepository.swift
//  SwiftApp
//
//  Created by kou on 2018/11/04.
//  Copyright © 2018 kou. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import RxSwift
import RxCocoa
import Realm
import RealmSwift

class FirebaseSignInRepository {
    
    private let auth = Auth.auth()
    let realm: Realm
    
    init() {
        self.realm = try! Realm()
    }
    
    func signIn(withEmail email: String, password: String) -> Observable<AuthResult> {
        return auth.rx.signIn(withEmail: email, password: password)
            .map { .succeed(result: $0) }
            .catchError { Observable.just(.failed(error: $0))}
    }
    
    func signUp(withEmail email: String, password: String) -> Observable<AuthResult> {
        return auth.rx.createUser(withEmail: email, password: password)
            .map { .succeed(result: $0) }
            .catchError { Observable.just(.failed(error: $0))}
    }
    
    func errorMessage(result: AuthResult) -> String? {
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
        return nil
    }
    
    func createUser(new: AuthDataResult, name: String) -> Observable<Void> {
        return createFirestoreUser(new: new, name: name)
            .map {[unowned self] _ in self.createLocalUser(new: new, name: name)}
    }
    
    func createLocalUser(new: AuthDataResult, name: String) -> Void {
        let changeValue: [String: Any?] = ["email": new.user.email,
                                            "displayName": name,
                                            "uid": new.user.uid]
        try! realm.write {
            realm.create(AuthUser.self, value: changeValue, update: true)
        }
    }
    
    private func createFirestoreUser(new: AuthDataResult, name: String) -> Observable<Void>{
        let dictionary: [String: Any?] = ["name": name]
        
        return Firestore.firestore()
            .collection("Users")
            .document(new.user.uid)
            .rx.setData(dictionary)
            .map { _ in}
    }
}
