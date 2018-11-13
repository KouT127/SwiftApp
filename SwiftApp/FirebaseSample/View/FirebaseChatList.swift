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
    let db = Firestore.firestore()
    var sections: [RoomSection] = []
    let stateEvent = BehaviorRelay<SectionedTableViewState?>(value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = FirebaseChatListView.dataSource()
        
        let sections: [RoomSection] = [RoomSection(header: "Rooms", rooms: [], updated: Date())]
        
        let state = stateEvent
            .asObservable()
            .flatMap { $0.flatMap {Observable.just($0)} ?? Observable.empty() }
        
        let initialState = SectionedTableViewState(sections: sections)
        stateEvent.accept(initialState)
        
        let addCommand = addButton.rx.tap.asObservable()
            .withLatestFrom(state)
            .map {[unowned self] state in
                self.addItem(oldSections: state.sections , item: FirebaseRoom(roomId: "1", roomName: "name", roomDescription: "desc", date: Date()), section: 0)}
        
        let initialCommand = getInitialData()
            .withLatestFrom(state){ ($0, $1) }
            .map {[unowned self] data, state  -> SectionedTableViewState in
                return self.initialSection(oldSections: state.sections, item: data, section: 0)}
        
        let updateCommand = getUpdateData()
            .flatMap { $0.flatMap { Observable.just($0) } ?? Observable.empty() }
            .withLatestFrom(state) {($0, $1)}
            .map {[unowned self]  data, state in
                self.addItem(oldSections: state.sections , item: data, section: 0)}
        
        
        let deleteCommand = tableView.rx.itemDeleted.asObservable()
            .withLatestFrom(state){ ( $0, $1)}
            .map {[unowned self] index, state in
                self.deleteItem(oldSections: state.sections, index: index)}
        
        
        let movedCommand = tableView.rx.itemMoved
            .withLatestFrom(state) { ($0, $1)}
            .map {[unowned self] event, state in
                self.moveItem(oldSections: state.sections, sourceIndex: event.sourceIndex, destinationIndex: event.destinationIndex)}
        
        
        Observable.of(initialCommand, updateCommand, deleteCommand, movedCommand)
            .merge()
            .do(onNext: {[unowned self] state in self.stateEvent.accept(state)})
            .map { $0.sections }
            .share()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        tableView.setEditing(true, animated: true)
    }
    
    private func getInitialData() -> Observable<[FirebaseRoom]> {
        return db.collection("rooms").rx.listen()
            .map { value -> [FirebaseRoom] in
                var rooms: [FirebaseRoom] = []
                value.documentChanges.forEach { diff in
                    if diff.type == .added {
                        let data = diff.document.data()
                        guard let roomName = data["roomName"] as? String else { return }
                        guard let roomDescription = data["roomDescription"] as? String else { return }
                        guard let date = data["date"] as? Date else { return }
                        let roomId =  diff.document.documentID
                        let room: FirebaseRoom = FirebaseRoom(roomId: roomId, roomName: roomName, roomDescription: roomDescription, date: date)
                        rooms.append(room)
                    }
                }
                return rooms
            }
    }
    
    private func getUpdateData() -> Observable<FirebaseRoom?> {
        return db.collection("rooms").rx.listen()
            .map { value -> FirebaseRoom? in
                var room: FirebaseRoom?
                value.documentChanges.forEach { diff in
                    if diff.type == .modified {
                        let data = diff.document.data()
                        guard let roomName = data["roomName"] as? String else { return }
                        guard let roomDescription = data["roomDescription"] as? String else { return }
                        guard let date = data["date"] as? Date else { return }
                        let roomId =  diff.document.documentID
                        room = FirebaseRoom(roomId: roomId, roomName: roomName, roomDescription: roomDescription, date: date)
                    }
                }
                return room
        }
    }
    
    func initialSection(oldSections: [RoomSection] ,item: [FirebaseRoom], section: Int) -> SectionedTableViewState {
        var sections = oldSections
        let items = sections[section].items + item
        sections[section] = RoomSection(original: sections[section], items: items)
        return SectionedTableViewState(sections: sections)
    }
    
    func addItem(oldSections: [RoomSection] ,item: FirebaseRoom, section: Int) -> SectionedTableViewState {
        var sections = oldSections
        let items = sections[section].items + item
        sections[section] = RoomSection(original: sections[section], items: items)
        return SectionedTableViewState(sections: sections)
    }
    
    func deleteItem(oldSections: [RoomSection], index: IndexPath) -> SectionedTableViewState {
        var sections = oldSections
        print(index.section)
        var items = sections[index.section].items
        print(items)
        items.remove(at: index.row)
        sections[index.section] = RoomSection(original: sections[index.section], items: items)
        return SectionedTableViewState(sections: sections)
    }
    
    func moveItem(oldSections: [RoomSection] ,sourceIndex: IndexPath, destinationIndex: IndexPath) -> SectionedTableViewState{
        var sections = oldSections
        var sourceItems = sections[sourceIndex.section].items
        var destinationItems = sections[destinationIndex.section].items
        
        if sourceIndex.section == destinationIndex.section {
            destinationItems.insert(destinationItems.remove(at: sourceIndex.row),
                                    at: destinationIndex.row)
            let destinationSection = RoomSection(original: sections[destinationIndex.section], items: destinationItems)
            sections[sourceIndex.section] = destinationSection
            
            return SectionedTableViewState(sections: sections)
        } else {
            let item = sourceItems.remove(at: sourceIndex.row)
            destinationItems.insert(item, at: destinationIndex.row)
            let sourceSection = RoomSection(original: sections[sourceIndex.section], items: sourceItems)
            let destinationSection = RoomSection(original: sections[destinationIndex.section], items: destinationItems)
            sections[sourceIndex.section] = sourceSection
            sections[destinationIndex.section] = destinationSection
            
            return SectionedTableViewState(sections: sections)
        }
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
                return true
        },
            canMoveRowAtIndexPath: { _, _ in
                return true
        }
        )
    }
}

    
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

func + <T>(lhs: [T], rhs: T) -> [T] {
    var copy = lhs
    copy.append(rhs)
    return copy
}
