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

class FirebaseAuthView: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.rx.tap
            .asDriver()
            .drive(onNext: {[unowned self] _ in
                self.toSignUp()
            })
            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .asDriver()
            .drive(onNext: {[unowned self] _ in
                self.toSignIn()
            })
            .disposed(by: disposeBag)
    }
    
    private func toSignIn() {
        let storyboard = UIStoryboard(name: "FirebaseSignIn", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()! as! FirebaseSignInView
        viewController.auth = .signIn
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    private func toSignUp() {
        let storyboard = UIStoryboard(name: "FirebaseSignIn", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()! as! FirebaseSignInView
        viewController.auth = .signUp
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
