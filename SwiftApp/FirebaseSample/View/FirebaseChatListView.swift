//
//  FirebaseChatList.swift
//  SwiftApp
//
//  Created by kou on 2018/11/09.
//  Copyright © 2018 kou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import FirebaseFirestore

class FirebaseChatListView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = FirebaseChatListView.dataSource()
        let viewModel = FirebaseChatListViewModel(
            addTaps: addButton.rx.tap.asObservable(),
            dependency: (
                repository: FirebaseChatListRepository(),
                accessor: .shared,
                wireframe: .shared
            )
        )
        
        let userButton = UIBarButtonItem(title: "User", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItems = [userButton]
        
        tableView.rx.modelSelected(FirebaseRoom.self)
            .subscribe(onNext: {[unowned self] cell in
                self.toChat(documentId: cell.roomId, naviTitle: cell.roomName)
            })
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .asObservable()
            .subscribe(onNext: {[unowned self] cell in
                self.toCreateView()
            })
            .disposed(by: disposeBag)
        
        userButton.rx.tap
            .asObservable()
            .subscribe(onNext: {[unowned self] _ in
                self.toUser()
            })
            .disposed(by: disposeBag)
        
        viewModel.updatedDataSource
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
  
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        tableView.setEditing(true, animated: true)
    }
    
    private func toCreateView(){
        let storyboard = UIStoryboard(name: "FirebaseCreateRoom", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()!
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func toChat(documentId: String?, naviTitle: String?){
        let storyboard = UIStoryboard(name: "FirebaseChat", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()! as! FirebaseChatView
        viewController.documentId = documentId
        viewController.navigationTitle = naviTitle
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    private func toUser(){
        let storyboard = UIStoryboard(name: "FirebaseUser", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()! as! FirebaseUserView
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension FirebaseChatListView {
    static func dataSource() -> RxTableViewSectionedAnimatedDataSource<RoomSection> {
        return RxTableViewSectionedAnimatedDataSource(
            animationConfiguration: AnimationConfiguration(insertAnimation: .top,
                                                           reloadAnimation: .fade,
                                                           deleteAnimation: .left),
            configureCell: { (dataSource, table, idxPath, item) in
                let cell = table.dequeueReusableCell(withIdentifier: "ChatListCell", for: idxPath) as! FirebaseChatListCell
                cell.docId.text = item.roomId
                cell.roomName.text = item.roomName
                cell.roomDescription.text = item.roomDescription
                return cell
        },
            titleForHeaderInSection: { (ds, section) -> String? in
                return ds[section].header
        },
            canEditRowAtIndexPath: { _, _ in
                return false
        },
            canMoveRowAtIndexPath: { _, _ in
                return false
        }
        )
    }
}
