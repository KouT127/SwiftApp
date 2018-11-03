//
//  AuthSampleView.swift
//  SwiftApp
//
//  Created by kou on 2018/11/03.
//  Copyright © 2018 kou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AuthSampleView: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let auth = FirebaseAuth.shared

        let email = self.email.rx.text.orEmpty.asObservable().debug()
        let password = self.password.rx.text.orEmpty.asObservable()
        let inputInfo = Observable.combineLatest(email, password).debug()
        
        self.loginButton.rx.tap
            .asObservable()
            .withLatestFrom(inputInfo)
            .debug()
            .flatMap{ auth.signIn(withEmail: $0, password: $1)}
            .subscribe(onNext: { authResult in
                switch authResult {
                case .success(let data):
                    print(data)
                case .failed(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
    }

}
