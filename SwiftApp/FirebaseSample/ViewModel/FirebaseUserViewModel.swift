//
//  FirebaseCreateUserViewModel.swift
//  SwiftApp
//
//  Created by kou on 2018/11/23.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FirebaseUserViewModel {
    
    typealias Input = (
        name: Observable<String>,
        profile: Observable<String>,
        updateTaps: Observable<Void>,
        image: Observable<Data>
    )
    
    typealias Dependency = (
        repository: FirebaseUserRepository,
        accessor: Accessor,
        wireframe: DefaultWireframe
    )
    
    let userInfoRelay = BehaviorRelay<User?>(value: nil)
    let disposeBag = DisposeBag()
    
    let updateInfo: Driver<Void>
    
    init(input: Input, dependency: Dependency) {
        
        let currentUserInfo = userInfoRelay
            .asObservable()
            .filterNil()
        
        Observable
            .just(dependency.accessor.realm.objects(AuthUser.self).first)
            .filterNil()
            .map { User(uid: $0.uid, name: $0.displayName ?? "" , profile: $0.profile)}
            .bind(to: userInfoRelay)
            .disposed(by: disposeBag)
        
        let changeNameUser = input.name
            .withLatestFrom(currentUserInfo){($0,$1)}
            .map {dependency.repository.updateUser(oldUser: $1, newName: $0)}
        
        let changeProfileUser = input.profile
            .withLatestFrom(currentUserInfo){($0,$1)}
            .map {dependency.repository.updateUser(oldUser: $1, newProfile: $0)}
        
        Observable
            .merge(changeNameUser, changeProfileUser)
            .bind(to: userInfoRelay)
            .disposed(by: disposeBag)
        
        //TODO:ErrorHandle
        //TODO:画像がない場合を考える。
        let userInfo = input.updateTaps
            .withLatestFrom(input.image)
            .debug("image")
            .flatMap { image -> Observable<URL> in
                return dependency.repository.uploadImage(image)}
            .debug("after")
            .withLatestFrom(currentUserInfo) {($0, $1)}
            .debug("afterAfter")
            .share()
        
        //TODO:ErrorHandle
        let updateRemoteResult = userInfo
            .flatMap { url, user in
                return dependency.repository.updateRemoteUser(name: user.name, profile: user.profile, imageUrl: url, documentId: user.uid)}
            .debug("remote")
        
        let updateLocalResult = userInfo
            .map { url, user -> Void in
                return dependency.repository.updateLocalUser(uid: user.uid, name: user.name, profile: user.profile, url: url.description)}
            .debug("local")
        
        updateInfo = Observable
            .combineLatest(updateLocalResult,updateRemoteResult)
            .map{ _ in}
            .asDriver(onErrorDriveWith: Driver<Void>.empty())
    }
    
}
