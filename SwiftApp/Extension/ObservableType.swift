//
//  ObservableType.swift
//  SwiftApp
//
//  Created by kou on 2018/11/23.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation
import RxSwift

//RxOptionalから抜粋
public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    public var value: Wrapped? {
        //Optional型をWrapped?型に変換
        return self
    }
}

public extension ObservableType where E: OptionalType {
    public func filterNil() -> Observable<E.Wrapped> {
        return self.flatMap { element -> Observable<E.Wrapped> in
            guard let value = element.value else {
                return Observable<E.Wrapped>.empty()
            }
            return Observable<E.Wrapped>.just(value)
        }
    }
}
