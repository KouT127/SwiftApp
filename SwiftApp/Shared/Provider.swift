//
//  Provider.swift
//  SwiftApp
//
//  Created by kou on 2018/10/27.
//  Copyright © 2018 kou. All rights reserved.
//

import Moya
import RxSwift

class Provider {
    static let shared = Provider()
    private let provider = MoyaProvider<GitHub>()
    
    func request() -> Single<Profile>  {
        return provider.rx.request(.userProfile("KouT127"))
            .filterSuccessfulStatusCodes()
            .map(Profile.self)
    }
}
