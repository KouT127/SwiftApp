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

extension Date {

    func toString(_ format: String = "yyyy/MM/dd", timeZone: Bool = false) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if timeZone {
            formatter.timeZone = TimeZone.current
            formatter.locale = Locale.current
        }
        
        return formatter.string(from: self)
    }
}
