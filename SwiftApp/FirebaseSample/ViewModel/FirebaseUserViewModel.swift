//
//  FirebaseCreateUserViewModel.swift
//  SwiftApp
//
//  Created by kou on 2018/11/23.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation

import UIKit
import RxSwift
import RxCocoa

class FirebaseUserViewModel {
    
    typealias Input = (
        name: Observable<String>,
        profile: Observable<String>,
        updateTaps: Observable<Void>,
        imageTaps: Observable<Void>
    )
    
    typealias Dependency = (
        imagePickerService: ImagePickerService,
        repository: FirebaseUserRepository,
        accessor: Accessor,
        wireframe: DefaultWireframe
    )
    
    let userInfoRelay = BehaviorRelay<User?>(value: nil)
    let disposeBag = DisposeBag()
    
    let updateInfo: Driver<Void>
    let imageInfo: Driver<Data>
    
    init(input: Input, dependency: Dependency) {
        
        let image = input.imageTaps
            .flatMap { dependency.imagePickerService.pickPhoto()}
            .map { $0?.jpegData(compressionQuality: 0.9)}
            .filterNil()
            .share()
        
        imageInfo = image
            .asDriver(onErrorDriveWith: Driver.empty())
        
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
        //TODO:現在表示している画像を保持する。
        let userInfo = input.updateTaps
            .withLatestFrom(image)
            .withLatestFrom(currentUserInfo) {($0, $1)}
            .share()
        
        //TODO:ErrorHandle
        let updateRemoteResult = userInfo
            .flatMap { image, user in
                return dependency.repository.updateRemoteUser(name: user.name, profile: user.profile, image: image, uid: user.uid)}
        
        let updateLocalResult = userInfo
            .map { image, user -> Void in
                return dependency.repository.updateLocalUser(uid: user.uid, name: user.name, profile: user.profile, image: image)}
        
        updateInfo = Observable
            .combineLatest(updateLocalResult,updateRemoteResult)
            .map{ _ in}
            .asDriver(onErrorDriveWith: Driver<Void>.empty())
    }
    
}
