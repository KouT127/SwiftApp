//
//  SampleViewModel.swift
//  SwiftApp
//
//  Created by kou on 2018/08/20.
//  Copyright © 2018年 kou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SampleViewModel {
    
    let items: Observable<[Item]>
    
    typealias Input = (
        search: Observable<String>,
        listTaps: Observable<Item>
    )
    
    private let bag = DisposeBag()
    
    init(input: Input, model: SampleRepository = SampleRepository()) {
        
        let repositories = input.search
            .debug("before")
            .flatMap { query -> Observable<Repositories> in
                if query != "" {
                    return model.requestRepositories(query).asObservable()
                }
                return Observable.empty()
            }.share()
            .debug("after")
        
//        let totalCount = repositories.map{ $0.totalCount}
        items = repositories.map{ $0.items }
    }
}
