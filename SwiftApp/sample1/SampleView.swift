//
//  SampleView.swift
//  SwiftApp
//
//  Created by kou on 2018/08/20.
//  Copyright © 2018年 kou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import RxMoya

class SampleView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let disposeBag = DisposeBag()
        
        let provider = MoyaProvider<GitHub>()
        provider.rx.request(.userProfile("KouT127"))
            .filterSuccessfulStatusCodes()
            .map(Profile.self)
            .subscribe(onSuccess: { profile in
                print(profile)
            }) { (error) in
                print("errorだお")
            }
//            .disposed(by: disposeBag)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
