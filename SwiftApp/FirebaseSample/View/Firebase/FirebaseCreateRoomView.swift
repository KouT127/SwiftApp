//
//  FirebaseCreateRoomView.swift
//  SwiftApp
//
//  Created by kou on 2018/11/18.
//  Copyright © 2018 kou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class FirebaseCreateRoomView: UIViewController {

    @IBOutlet weak var inputTitle: UITextField!
    @IBOutlet weak var inputDescription: UITextField!
    
    @IBOutlet weak var addButton: RoundButton!
    
    let db = Firestore.firestore()
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = inputTitle.rx.text.orEmpty.asDriver()
        let description = inputDescription.rx.text.orEmpty.asDriver()
        
        let inputData = Driver.combineLatest(title, description)
        
        addButton.rx.tap
            .asDriver()
            .withLatestFrom(inputData)
            .drive(onNext: {[unowned self] title, description in
                self.addRoom(name: title, description: description)
                self.back()
            })
            .disposed(by: disposeBag)
    }
    
    private func addRoom(name: String, description: String) {
        let room: [String: Any] = ["roomName":name,
                                   "roomDescription": description,
                                   "date": FieldValue.serverTimestamp()]
        
        db.collection("rooms")
            .addDocument(data: room)
    }

    private func back() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
