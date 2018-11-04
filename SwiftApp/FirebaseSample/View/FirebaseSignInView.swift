//
//  SignIn.swift
//  SwiftApp
//
//  Created by kou on 2018/11/04.
//  Copyright © 2018 kou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FirebaseSignInView: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel: FirebaseSignInViewModel?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = FirebaseSignInViewModel(
            input: (
                email: self.email.rx.text.orEmpty.asObservable(),
                password: self.password.rx.text.orEmpty.asObservable(),
                loginTaps: self.loginButton.rx.tap.asObservable()
            )
        )
        self.viewModel = viewModel
        
        viewModel.isValid
            .drive(onNext: { valid in
                self.loginButton.isEnabled = valid
                self.loginButton.alpha = valid ? 1 : 0.6
            })
            .disposed(by: disposeBag)
        
        viewModel.authResult
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { authResult in
                switch authResult {
                case .succeed(let data):
                    //TODO 遷移処理
                    print(data)
                case .failed(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
    }
    
}
