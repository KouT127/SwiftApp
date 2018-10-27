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
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let provider = Provider.shared
        provider.request()
            .subscribe(onSuccess: { profile in
                print(profile)
            }, onError: { error in
                print("errorだよ")
            })
            .disposed(by: disposeBag)

        // Do any additional setup after loading the view.
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("denit")
    }
}
