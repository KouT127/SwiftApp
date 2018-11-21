//
//  FirebaseCreateUserView.swift
//  SwiftApp
//
//  Created by kou on 2018/11/19.
//  Copyright © 2018 kou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore
import FirebaseStorage
import RxMediaPicker
import Photos
import FirebaseStorage

class FirebaseCreateUserView: UIViewController, RxMediaPickerDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var profile: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var userImageButton: RoundButton!
    
    var picker: RxMediaPicker!
    let db = Firestore.firestore()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        checkPermission()
        imagePicker()

        let info = Driver.combineLatest(name.rx.text.asDriver(), profile.rx.text.asDriver())
            
        updateButton.rx.tap.asDriver()
            .withLatestFrom(info)
            .map {[unowned self] name, profile in
                self.createUser(name: name, profile: profile)
            }
            .drive(onNext: { [unowned self] _ in
                self.back()
            })
            .disposed(by: disposeBag)
        
    }
    
    private func imagePicker(){
        picker = RxMediaPicker(delegate: self)
        
        userImageButton.rx.tap
            .asObservable()
            .debug()
            .flatMap {self.pickPhoto()}
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { image in
                let data = image.1?.jpegData(compressionQuality: 0.8)
                if let data = data {
                    Storage.storage().reference(forURL: "").child("images/example.jpg").putData(data)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func present(picker: UIImagePickerController) {
        present(picker, animated: true, completion: nil)
    }
    
    func dismiss(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
    
    func pickPhoto() -> Observable<(UIImage, UIImage?)>{
        return picker.selectImage(editable: true)
    }
    
    private func createUser(name: String?, profile: String?){
        //imageは最後に実装する。
        let userInfo: [String: Any?] = ["name": name,
                                      "profile": profile,
                                      "createdAt": FieldValue.serverTimestamp()]
        db.collection("Users")
            .addDocument(data: userInfo)
    }
    
    private func back() {
        self.dismiss(animated: true, completion: nil)
    }

}
