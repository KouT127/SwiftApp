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
            .bind(to: tableView.rx.items) {[unowned self](_, _, element) in
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "GitHubCell") as! GitHubCell
                cell.name.text = element.fullName
                cell.githubDescription.text = element.description
                cell.watcher.text = String(element.watchers)
                cell.language.text = element.language
                print(element)
                return cell
            }
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("denit")
    }
}
