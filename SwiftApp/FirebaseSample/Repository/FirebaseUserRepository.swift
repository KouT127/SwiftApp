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
    
    func updateRemoteUser(name: String?, profile: String?, image: Data?, uid: String) -> Observable<Void>{
        
        return uploadImage(uid: uid, image: image!)
            .flatMap {[unowned self] url -> Observable<Void> in
                let userInfo: [String: Any?] = ["name": name,
                                                "profile": profile,
                                                "imageUrl": url.description,
                                                "createdAt": FieldValue.serverTimestamp()]
                return self.updateFirestoreUser(userInfo, uid)
        }
    }
    
    func updateLocalUser(uid: String, name: String? = nil, profile: String? = nil, image: Data? = nil) {
        var changeValue: [String: Any] = ["uid": uid]
        if let name = name {
            changeValue = changeValue + ["displayName": name]
        }
        if let profile = profile {
            changeValue = changeValue + ["profile": profile]
        }
        if let image = image {
            changeValue = changeValue + ["image": image]
        }
        try! realm.write {
            realm.create(AuthUser.self, value: changeValue, update: true)
        }
        print(realm.objects(AuthUser.self))
    }
    
    //TODO: errorhandle
    private func updateFirestoreUser(_ dictionary: [String: Any?],_ uid: String) -> Observable<Void>{
        return Firestore.firestore()
            .collection("Users")
            .document(uid)
//            .document(uid)
            .rx.updateData(dictionary)
    }
    
    //TODO: errorhandle
    private func uploadImage(uid: String, image: Data) -> Observable<URL>{
        
        return Storage.storage()
            .reference(forURL: getStorageUrl())
            .child("user_images/\(uid)")
            .rx.putData(image)
            .map { $0}
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
    
    func updateUser(oldUser: User, newName: String? = nil, newProfile: String? = nil, newImage: Data? = nil) -> User{
        return User(uid: oldUser.uid, name: newName ?? oldUser.name, profile: newProfile ?? oldUser.profile, image: newImage ?? oldUser.image)
    }
}

//追加のみ
func + <K,V>(left: Dictionary<K,V>, right: Dictionary<K,V>)
    -> Dictionary<K,V>
{
    var dictionary = left
    for (k, v) in right {
        dictionary[k] = v
    }
    return dictionary
}
