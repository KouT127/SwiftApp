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
    
    @IBOutlet weak var userNameStackView: UIStackView!
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var auth: AuthEnum? = nil
    var viewModel: FirebaseSignInViewModel?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeWords()
        
        let viewModel = FirebaseSignInViewModel(
            input: (
                userName: self.userName.rx.text.orEmpty.asObservable(),
                email: self.email.rx.text.orEmpty.asObservable(),
                password: self.password.rx.text.orEmpty.asObservable(),
                loginTaps: self.loginButton.rx.tap.asObservable(),
                auth: Observable.just(auth).flatMap { $0.flatMap { Observable.just($0) } ?? Observable.empty() }
            ),
            dependency: (
                repository: FirebaseSignInRepository(),
                accessor: .shared,
                wireframe: .shared
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
            .subscribe(onNext: {[unowned self] result in
                if result {
                    self.dismiss(animated: true, completion: nil)
                }
                print(result)
            })
            .disposed(by: disposeBag)
    }
    
    private func changeWords() {
        if case .signUp? = auth {
            self.loginButton.setTitle("登録する", for: .normal)
            self.titleLabel.text = "新規登録"
            self.userNameStackView.isHidden = false
        }
    }
}
