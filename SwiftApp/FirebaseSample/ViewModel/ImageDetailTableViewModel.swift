//
//  ImageParentTableViewModel.swift
//  SwiftApp
//
//  Created by kou on 2018/12/02.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ImageDetailTableViewModel {
    
    typealias Dependency = (
        repository: ImageDetailTableRepository,
        accessor: Accessor,
        wireframe: DefaultWireframe
    )
    
    let stateEvent = BehaviorRelay<SectionedParentViewState?>(value: nil)
    var sections: [ParentSection] = [ParentSection(header: "List",
                                                   contents: [Content(contentId: "",
                                                                      headerSection: [],
                                                                      imageSection: [],
                                                                      date: Date())],
                                                   updated: Date())]
    
    let updatedDataSource: Observable<[ParentSection]>
    
    let disposeBag = DisposeBag()
    
    init(dependency: Dependency) {
        
        let state = stateEvent
            .debug("state")
            .asObservable()
            .flatMap { $0.flatMap {Observable.just($0)} ?? Observable.empty() }
        
        let initialState = SectionedParentViewState(sections: sections)
        stateEvent.accept(initialState)
        
        let initialData = dependency.repository.getInitialData()
            .withLatestFrom(state){ ($0, $1) }
            .map { data, state  -> SectionedParentViewState in
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
