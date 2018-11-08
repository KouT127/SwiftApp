//
//  Realm.swift
//  SwiftApp
//
//  Created by kou on 2018/11/04.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation

import Foundation
import RealmSwift
import Realm
import RxSwift
import RxCocoa
import RxRealm


class Accessor {
    static let shared = Accessor()
    let realm: Realm
    
    private init() {
        //migrationを行う場合SchemaVersionを繰り上げる
        //リリース時初期化
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { _, _ in
                //                if (oldSchemaVersion < 1) {
                //                }
        })
        Realm.Configuration.defaultConfiguration = config
        
        self.realm = try! Realm()
        
    }
    
    ///データ書込
    func write(object: Object) -> Bool {
        self.realm.beginWrite()
        self.realm.add(object)
        
        do {
            try self.realm.commitWrite()
        } catch {
            if self.realm.isInWriteTransaction {
                self.realm.cancelWrite()
            }
            return false
        }
        return true
    }
    func addRealmData(object: Object) {
        self.realm.add(object)
    }
    func deleteRealmData(data: Object.Type) {
        let objectData = realm.objects(data)
        self.realm.delete(objectData)
    }
    ///filterしたデータを削除する。
    func deleteFilteredData<T: Object>(filteredData: Results<T>) {
        self.realm.delete(filteredData)
    }
}
