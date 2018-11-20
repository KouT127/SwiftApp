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

class FirebaseCreateUserView: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var profile: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    
    let db = Firestore.firestore()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

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
