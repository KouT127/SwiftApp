//
//  WKWebView.swift
//  SwiftApp
//
//  Created by kou on 2018/11/23.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation
import RxSwift
import WebKit

extension Reactive where Base: WKWebView {
    
    public var estimatedProgress: Observable<Float> {
        return self.observe(Double.self, "estimatedProgress")
            .flatMap { $0.flatMap { Observable.just($0) } ?? Observable.empty() }
            .map{ Float($0) }
    }
    
    public var loading: Observable<Bool> {
        return self.observe(Bool.self, "loading")
            .flatMap { $0.flatMap { Observable.just($0) } ?? Observable.empty() }
    }
    
    public var url: Observable<URL> {
        return self.observe(URL.self, "URL")
            .flatMap { $0.flatMap { Observable.just($0) } ?? Observable.empty() }
    }
    
    public var canGoBack: Observable<Bool> {
        return self.observe(Bool.self, "canGoBack")
            .flatMap { $0.flatMap { Observable.just($0) } ?? Observable.empty() }
    }
    
    public var canGoForward: Observable<Bool> {
        return self.observe(Bool.self, "canGoForward")
            .flatMap { $0.flatMap { Observable.just($0) } ?? Observable.empty() }
    }
    
}
