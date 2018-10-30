//
//  extension.swift
//  SwiftApp
//
//  Created by bird on 2018/10/30.
//  Copyright © 2018年 kou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import WebKit

extension Reactive where Base: WKWebView {
    
    public var estimatedProgress: Observable<Float> {
        return self.observe(Double.self, "estimatedProgress")
            .flatMap { $0.flatMap { Observable.just($0) } ?? Observable.empty() }
            .map{ Float($0) }
    }
}
