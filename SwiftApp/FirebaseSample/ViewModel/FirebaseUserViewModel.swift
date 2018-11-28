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
    
    private let userInfoRelay = BehaviorRelay<User?>(value: nil)
    private let networkEvent: PublishRelay<Bool> = PublishRelay()
    let disposeBag = DisposeBag()
    
    let updateInfo: Driver<Void>
    let imageInfo: Driver<Data>
    let network: Signal<Bool>
    let currentUserInfo: Driver<User>
    
    init(input: Input, dependency: Dependency) {
        
        let currentUser = userInfoRelay
            .asObservable()
            .filterNil()
        
        network = networkEvent
            .asSignal()
        
        let image = input.imageTaps
            .flatMap { dependency.imagePickerService.pickPhoto()}
            .map { $0?.jpegData(compressionQuality: 0.9)}
            .filterNil()
            .share()
        
        imageInfo = image
            .asDriver(onErrorDriveWith: Driver.empty())
        
        currentUserInfo = currentUser
            .asDriver(onErrorDriveWith: Driver.empty())

        let localUser = Observable.just(())
            .map { _ in dependency.repository.fetchLocalUser()}
        
        let changeNameUser = input.name
            .withLatestFrom(currentUser){($0,$1)}
            .map {dependency.repository.updateUser(oldUser: $1, newName: $0)}
        
        let changeProfileUser = input.profile
            .withLatestFrom(currentUser){($0,$1)}
            .map {dependency.repository.updateUser(oldUser: $1, newProfile: $0)}
        
        let changeImageUser = image
            .withLatestFrom(currentUser){($0,$1)}
            .map {dependency.repository.updateUser(oldUser: $1, newImage: $0)}
        
        Observable
            .merge(localUser, changeNameUser, changeProfileUser, changeImageUser)
            .bind(to: userInfoRelay)
            .disposed(by: disposeBag)
        
        //TODO:ErrorHandle
        //TODO:現在表示している画像を保持する。
        let userInfo = input.updateTaps
            .do(onNext: {[weak networkEvent]_ in networkEvent?.accept(true)})
            .withLatestFrom(currentUser)
            .share()
        
        //TODO:ErrorHandle
        let updateRemoteResult = userInfo
            .flatMap { user in
                return dependency.repository.updateRemoteUser(name: user.name, profile: user.profile, image: user.image, uid: user.uid)}
        
        let updateLocalResult = userInfo
            .map { user -> Void in
                return dependency.repository.updateLocalUser(uid: user.uid, name: user.name, profile: user.profile, image: user.image)}
        
        updateInfo = Observable
            .combineLatest(updateLocalResult,updateRemoteResult)
            .map{ _ in }
            .do(onNext: {[weak networkEvent] _ in networkEvent?.accept(false)})
            .asDriver(onErrorDriveWith: Driver.empty())
        
        Observable
            .just(dependency.repository.realm.objects(AuthUser.self).first)
            .filterNil()
            .map { User(uid: $0.uid, name: $0.displayName ?? "" , profile: $0.profile, image: $0.image)}
            .bind(to: userInfoRelay)
            .disposed(by: disposeBag)
    }
}
