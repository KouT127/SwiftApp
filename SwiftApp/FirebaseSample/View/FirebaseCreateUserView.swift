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

    override func viewDidLoad() {
        super.viewDidLoad()

        Driver.combineLatest(name.rx.text.asDriver(), profile.rx.text.asDriver())
            .map{[unowned self] name, profile in
                self.createUser(name: name, profile: profile)
            }
    }
    
    private func createUser(name: String?, profile: String?){
        //imageは最後に実装する。
        
        let userInfo: [String: Any?] = ["name": name,
                                      "profile": profile,
                                      "createdAt": FieldValue.serverTimestamp()]
        db.collection("rooms")
            .addDocument(data: userInfo)
    }

}
