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

typealias Input = (
    email: Observable<String>,
    password: Observable<String>,
    loginTaps: Observable<Void>
)

class FirebaseSignInViewModel {
    
    let isValid: Driver<Bool>
    let authSucceed: Observable<Bool>
    
    let disposeBag = DisposeBag()
    
    init(input: Input, repository: FirebaseSignInRepository = FirebaseSignInRepository(), accessor: Accessor = .shared) {
        
        let inputInfo = Observable
            .combineLatest(input.email, input.password)
            .share()
        
        isValid = inputInfo
            .map { $0.count >= 3 && $1.count >= 6 }
            .asDriver(onErrorJustReturn: false)
        
        let authResult = input.loginTaps
            .withLatestFrom(inputInfo)
            .flatMap { repository.signIn(withEmail: $0, password: $1)}
            .share()
        
        authSucceed = authResult
            .map { result in
                switch result {
                case .succeed( let data ):
                    let user = repository.createAuthUser(new: data)
                    return accessor.write(object: user)
                default:
                    break
                }
                return false
            }
        
        let authFailedMessage = authResult
            .map { repository.errorMessage(result: $0) }
            .flatMap { $0.flatMap { Observable.just($0) } ?? Observable.empty() }
        
        let alertResult = authFailedMessage
            .map { message in
                let firebaseAlertInfo = AlertInfo(title: "エラー", message: message, cancel: .ok)
                return firebaseAlertInfo
            }.flatMap { alertInfo in
                DefaultWireframe.shared.promptFor(alertInfo)
            }
        
        alertResult
            .subscribe(onNext: { action in
                //TODO: actionによって使い分ける。
                return
            })
            .disposed(by: disposeBag)
    }
}
