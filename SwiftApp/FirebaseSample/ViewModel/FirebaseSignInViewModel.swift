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
    let authResult: Observable<AuthResult>
    
    init(input: Input, repository: FirebaseSignInRepository = FirebaseSignInRepository()) {
        
        let inputInfo = Observable
            .combineLatest(input.email, input.password)
            .share()
        
        isValid = inputInfo
            .map { $0.count >= 3 && $1.count >= 6 }
            .asDriver(onErrorJustReturn: false)
        
        authResult = inputInfo
            .flatMap { repository.signIn(withEmail: $0, password: $1)}
        
    }
    
}
