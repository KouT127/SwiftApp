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
    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: SampleViewModel?
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = SampleViewModel(
            input: (
                search: search.rx.text.orEmpty.asObservable(),
                listTaps: tableView.rx.modelSelected(Item.self).asObservable()
            )
        )
        self.viewModel = viewModel

        viewModel.items
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { item in
                print(item.first)
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
