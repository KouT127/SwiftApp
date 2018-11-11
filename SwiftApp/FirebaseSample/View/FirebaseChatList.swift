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
import FirebaseFirestore

class FirebaseChatListView: UIViewController {
    
//
//    private let db = Firestore.firestore()
//    let disposeBag = DisposeBag()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        viewModel.items
//            .observeOn(MainScheduler.instance)
//            .bind(to: tableView.rx.items) {[unowned self](_, _, element) in
//                let cell = self.tableView.dequeueReusableCell(withIdentifier: "GitHubCell") as! GitHubCell
//                cell.name.text = element.fullName
//                cell.githubDescription.text = element.description
//                cell.watcher.text = String(element.watchers)
//                cell.language.text = element.language
//                return cell
//            }
//            .disposed(by: disposeBag)
//
//        tableView.rx.modelSelected(Item.self)
//            .asObservable()
//            .subscribe(onNext: { [unowned self] item in
//                self.toBrowser(url: item.htmlUrl)
//            })
//            .disposed(by: disposeBag)
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.setToolbarHidden(true, animated: false)
//        navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // ここでFirebaseのメッセージ等を取得する。
//    private func setFirebaseListener() -> [room] {
//        var rooms: [room] = []
//        db.collection("rooms")
//            .addSnapshotListener{ snapShot, error in
//                guard let value = snapShot else { return }
//                value.documentChanges.forEach { diff in
//                    if diff.type == .added || diff.type == .modified {
//                        let data = diff.document.data()
//                        guard let roomName = data["roomName"] as? String else { return }
//                        let docId = diff.document.documentID
//                        rooms.append(room(roomName: roomName, roomDescription: nil, docId: docId))
//                    }
//                }
//        }
//        return rooms
//    }
//
//    private func toBrowser(url: String) {
//        let storyboard = UIStoryboard(name: "FirebaseChatView", bundle: nil)
//        let viewController = storyboard.instantiateInitialViewController() as! FirebaseChatView
//        self.navigationController?.pushViewController(viewController, animated: true)
//    }
//
//    deinit {
//        print("denit")
//    }
}

struct room {
    let roomName: String
    let roomDescription: String?
    let docId: String
    
    init(roomName: String, roomDescription: String?, docId: String) {
        self.roomName = roomName
        self.roomDescription = roomDescription
        self.docId = docId
    }
}
