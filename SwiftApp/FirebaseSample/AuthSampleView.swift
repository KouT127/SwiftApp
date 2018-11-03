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
import FirebaseAuth

class AuthSampleView: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let auth = FirebaseAuth()

        let email = self.email.rx.text.orEmpty.asObservable()
        let password = self.password.rx.text.orEmpty.asObservable()
        
        Observable.combineLatest(email, password)
            .flatMap{ auth.signIn(withEmail: $0, password: $1)}
            .subscribe(onNext: { authResult in
                print(authResult)
            })
            .disposed(by: disposeBag)
    }

}
