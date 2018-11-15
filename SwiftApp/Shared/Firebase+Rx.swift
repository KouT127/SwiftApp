//
//  FirebaseAuth+Rx.swift
//  SwiftApp
//
//  Created by kou on 2018/11/03.
//  Copyright © 2018 kou. All rights reserved.
//

import RxSwift
import FirebaseAuth
import FirebaseFirestore

extension Reactive where Base: Auth {

    public func signIn(withEmail email: String, password: String) -> Observable<AuthDataResult> {
        return Observable.create { observer in
            self.base.signIn(withEmail: email, password: password) { auth, error in
                if let error = error {
                    observer.onError(error)
                } else if let auth = auth {
                    observer.onNext(auth)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    public func createUser(withEmail email: String, password: String) -> Observable<AuthDataResult> {
        return Observable.create { observer in
            self.base.createUser(withEmail: email, password: password) { auth, error in
                if let error = error {
                    observer.onError(error)
                } else if let auth = auth {
                    observer.onNext(auth)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}

extension Reactive where Base: CollectionReference {
    public func addDocument(data: [String: Any]) -> Observable<DocumentReference> {
        return Observable<DocumentReference>.create { observer in
            var ref: DocumentReference?
            ref = self.base.addDocument(data: data) { error in
                if let error = error {
                    observer.onError(error)
                } else if let ref = ref {
                    observer.onNext(ref)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
extension Reactive where Base: Query {
    public func listen() -> Observable<QuerySnapshot> {
        return Observable<QuerySnapshot>.create { observer in
            let listener = self.base.addSnapshotListener() { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot {
                    observer.onNext(snapshot)
                }
            }
            return Disposables.create {
                listener.remove()
            }
        }
    }
}

extension Reactive where Base: DocumentReference {
    public func setData(_ documentData: [String: Any]) -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.base.setData(documentData) { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    public func getDocument() -> Observable<DocumentSnapshot> {
        return Observable.create { observer in
            self.base.getDocument { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot, snapshot.exists {
                    observer.onNext(snapshot)
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: FirestoreErrorDomain, code: FirestoreErrorCode.notFound.rawValue, userInfo: nil))
                }
            }
            return Disposables.create()
        }
    }
    public func listen() -> Observable<DocumentSnapshot> {
        return Observable<DocumentSnapshot>.create { observer in
            let listener = self.base.addSnapshotListener() { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot {
                    observer.onNext(snapshot)
                }
            }
            return Disposables.create {
                listener.remove()
            }
        }
    }
}