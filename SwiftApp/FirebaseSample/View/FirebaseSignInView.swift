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
    
    @IBOutlet weak var backButton: UIButton!
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
        
        viewModel.authSucceed
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                if result {
                    //TODO:繊維処理
                }
                print(result)
            })
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .asDriver()
            .drive(onNext: {[unowned self] _ in
                self.back()
            })
            .disposed(by: disposeBag)
    }
    
    private func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
