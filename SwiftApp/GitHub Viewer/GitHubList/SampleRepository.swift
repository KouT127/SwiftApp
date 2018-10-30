//
//  SampleRepository.swift
//  SwiftApp
//
//  Created by kou on 2018/10/27.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift
import RxCocoa

class SampleRepository {
    
    private let provider = MoyaProvider<GitHub>()
    
    func requestRepositories(_ query: String) -> Single<Repositories>  {
        return provider.rx.request(.repositories(query))
            .filterSuccessfulStatusCodes()
            .map(Repositories.self)
    }
}
