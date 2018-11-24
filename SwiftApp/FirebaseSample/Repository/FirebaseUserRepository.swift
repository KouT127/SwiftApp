//
//  FirebaseUserRepository.swift
//  SwiftApp
//
//  Created by kou on 2018/11/23.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxMediaPicker

import FirebaseFirestore
import FirebaseStorage

import Photos

import RealmSwift

class FirebaseUserRepository {
    
    let realm: Realm
    
    init() {
        self.realm = try! Realm()
    }
    
    func updateRemoteUser(name: String?, profile: String?, imageUrl: URL, documentId: String) -> Observable<Void>{
        //imageは最後に実装する。
        let userInfo: [String: Any?] = ["name": name,
                                        "profile": profile,
                                        "imageUrl": imageUrl.description,
                                        "createdAt": FieldValue.serverTimestamp()]
        return Firestore.firestore()
            .collection("Users")
            .document(documentId).rx.updateData(userInfo)
    }
    
    func uploadImage(_ image: Data) -> Observable<URL>{
        
        return Storage.storage()
            .reference(forURL: getStorageUrl())
            .child("user_images/asdfasdf.jpg")
            .rx.putData(image)
            .map { $0}
            .debug("meta")
            .flatMap { self.downloadUrl(path: $0.path)}
    }
    
    func downloadUrl(path: String?) -> Observable<URL>{
        return Storage.storage()
            .reference(forURL: getStorageUrl())
            .child(path ?? "")
            .rx.getDownloadUrl()
    }
    
    private func getStorageUrl() -> String{
        let filePath = Bundle.main.path(forResource: "Firebase", ofType: "plist" )
        let plist = NSDictionary(contentsOfFile: filePath!)!
        return (plist["StorageURL"]) as! String
    }
    
    func checkPermission() -> PHAuthorizationStatus{
        return PHPhotoLibrary.authorizationStatus()
//        switch photoAuthorizationStatus {
//        case .authorized:
//            return true
//        case .notDetermined:
//            PHPhotoLibrary.requestAuthorization({
//                (newStatus) in
//                print("status is \(newStatus)")
//                if newStatus ==  PHAuthorizationStatus.authorized {
//                    /* do stuff here */
//                    print("success")
//                }
//            })
//            print("It is not determined until now")
//        case .restricted:
//            // same same
//            print("User do not have access to photo album.")
//        case .denied:
//            // same same
//            print("User has denied the permission.")
//        }
    }
    
    func updateLocalUser(uid: String, name: String? = nil, profile: String? = nil, url: String? = nil) {
        var changeValue = ["uid": uid]
        if let name = name {
            changeValue = changeValue.merging(["name": name], uniquingKeysWith: +)
        }
        if let profile = profile {
            changeValue = changeValue.merging(["profile": profile], uniquingKeysWith: +)
        }
        if let url  = url {
            changeValue = changeValue.merging(["imageUrl": url.description], uniquingKeysWith: +)
        }
        try! realm.write {
            realm.create(AuthUser.self, value: changeValue, update: true)
        }
    }
    
    func updateUser(oldUser: User, newName: String? = nil, newProfile: String? = nil, newUrl: URL? = nil) -> User{
        return User(uid: oldUser.uid, name: newName ?? oldUser.name, profile: newProfile ?? oldUser.profile, url: newUrl)
    }
}
