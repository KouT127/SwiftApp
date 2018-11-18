//
//  FirebaseChatListViewModel.swift
//  SwiftApp
//
//  Created by kou on 2018/11/15.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FirebaseChatListViewModel {
    
    typealias Dependency = (
        repository: FirebaseChatListRepository,
        accessor: Accessor,
        wireframe: DefaultWireframe
    )
    
    let stateEvent = BehaviorRelay<SectionedTableViewState?>(value: nil)
    var sections: [RoomSection] = [RoomSection(header: "Rooms", rooms: [], updated: Date())]
    
    let updatedDataSource: Observable<[RoomSection]>
    
    let disposeBag = DisposeBag()
    
    init(addTaps: Observable<Void>, dependency: Dependency) {
        
        let state = stateEvent
            .debug("state")
            .asObservable()
            .flatMap { $0.flatMap {Observable.just($0)} ?? Observable.empty() }
        
        let initialState = SectionedTableViewState(sections: sections)
        stateEvent.accept(initialState)
        
        let initialData = dependency.repository.getInitialData()
            .withLatestFrom(state){ ($0, $1) }
            .map { data, state  -> SectionedTableViewState in
                return dependency.repository.initialItem(oldSections: state.sections, item: data, section: 0)}
        
        let updateData = dependency.repository.getUpdateData()
            .flatMap { $0.flatMap { Observable.just($0) } ?? Observable.empty() }
            .withLatestFrom(state) {($0, $1)}
            .map { data, state in
                dependency.repository.addItem(oldSections: state.sections , item: data, section: 0)}
        
        
        let roomData = Observable.of(initialData, updateData)
            .merge()
            .share()
            

        updatedDataSource = roomData
            .map { $0.sections }
            .share()
        
        roomData
            .subscribe(onNext: {self.stateEvent.accept($0)})
            .disposed(by: disposeBag)
        
    }
}
