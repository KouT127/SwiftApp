//
//  FirebaseSignInViewModel.swift
//  SwiftApp
//
//  Created by kou on 2018/11/04.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FirebaseSignInViewModel {
    
    typealias Input = (
        userName: Observable<String>,
        email: Observable<String>,
        password: Observable<String>,
        loginTaps: Observable<Void>,
        auth: Observable<AuthEnum>
    )
    typealias Dependency = (
        repository: FirebaseSignInRepository,
        accessor: Accessor,
        wireframe: DefaultWireframe
    )
    
    let isValid: Driver<Bool>
    let authSucceed: Observable<Bool>
    
    let disposeBag = DisposeBag()
    
    init(input: Input, dependency: Dependency) {
        
        let SignInInputInfo = Observable
            .combineLatest(input.auth, input.email, input.password)
            .filter { auth, _, _ in auth == .signIn}
            .share()
        
        let SignUpInputInfo = Observable
            .combineLatest(input.auth, input.userName ,input.email, input.password)
            .filter { auth, _, _, _ in auth == .signUp}
            .share()
        
        let signInValid = SignInInputInfo
            .map { _, email, password in email.count >= 3
                && password.count >= 6
            }
        
        let signUpValid = SignUpInputInfo
            .map { _, name, email, password -> Bool in name.count >= 3
                && email.count >= 3
                && password.count >= 6
            }
        
        isValid = Observable
            .of(signInValid, signUpValid)
            .merge()
            .asDriver(onErrorJustReturn: false)
        
        let signUpResult = input.loginTaps
            .withLatestFrom(SignUpInputInfo)
            .flatMap { _, name, email, password -> Observable<(AuthResult, String?)> in
                dependency.repository
                    .signUp(withEmail: email, password: password)
                    .map { ($0, name)}
            }
        
        let signInResult = input.loginTaps
            .withLatestFrom(SignInInputInfo)
            .flatMap { _, email, password -> Observable<(AuthResult, String?)> in
                dependency.repository
                    .signIn(withEmail: email, password: password)
                    .map { ($0, nil)}
            }
        
        
       let authResult = Observable.of(signUpResult, signInResult)
            .merge()
            .share()
        
        authSucceed = authResult
            .flatMap { result, name -> Observable<Bool> in
                switch result {
                case .succeed( let data ):
                    if let name = name {
                        return dependency.repository.createUser(new: data, name: name).map { _ in true }
                    } else {
                        //TODO:ログイン時にどこかでNameとかProfileとか取得
                        return Observable.just(dependency.repository.createLocalUser(new: data, name: "")).map { _ in true}
                    }
                default:
                    return Observable.just(false)
                }
            }
        
        let authFailedMessage = authResult
            .map { result, _ in dependency.repository.errorMessage(result: result) }
            .flatMap { $0.flatMap { Observable.just($0) } ?? Observable.empty() }
        
        let alertResult = authFailedMessage
            .map { message in
                let firebaseAlertInfo = AlertInfo(title: "エラー", message: message, cancel: .ok)
                return firebaseAlertInfo
            }.flatMap { alertInfo in
                dependency.wireframe.promptFor(alertInfo)
            }
        
        alertResult
            .subscribe(onNext: { action in
                //TODO: actionによって使い分ける。
                return
            })
            .disposed(by: disposeBag)
    }
}
