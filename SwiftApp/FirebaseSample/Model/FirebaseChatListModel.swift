//
//  FirebaseChatListModel.swift
//  SwiftApp
//
//  Created by kou on 2018/11/10.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class FirebaseChatListModel: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!
    
    
    let disposeBag = DisposeBag()
    var sections: [RoomSection] = []
    let stateEvent = BehaviorRelay<SectionedTableViewState?>(value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = FirebaseChatListModel.dataSource()
        
        let sections: [RoomSection] = [RoomSection(header: "Section 1", rooms: [], updated: Date()),
                                         RoomSection(header: "Section 2", rooms: [], updated: Date()),
                                         RoomSection(header: "Section 3", rooms: [], updated: Date())]
        
        let state = stateEvent.asObservable()
        let initialState = SectionedTableViewState(sections: sections)
        stateEvent.accept(initialState)
        
        let addCommand = addButton.rx.tap.asObservable()
            .withLatestFrom(state)
            .map {[unowned self] state in
                self.addItem(oldSections: state?.sections ?? [], item: FirebaseRoom(roomId: "1", roomName: "name", roomDescription: "desc", date: Date()), section: 0)}
        
        
        let deleteCommand = tableView.rx.itemDeleted.asObservable()
            .withLatestFrom(state){ ( $0, $1)}
            .map {[unowned self] index, state in
                self.deleteItem(oldSections: state?.sections ?? [], index: index)}
        
        
        let movedCommand = tableView.rx.itemMoved
            .withLatestFrom(state) { ($0, $1)}
            .map {[unowned self] event, state in
                self.moveItem(oldSections: state?.sections ?? [], sourceIndex: event.sourceIndex, destinationIndex: event.destinationIndex)}
        
        
        Observable.of(addCommand, deleteCommand, movedCommand)
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

extension FirebaseChatListModel {
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

func + <T>(lhs: [T], rhs: T) -> [T] {
    var copy = lhs
    copy.append(rhs)
    return copy
}

struct SectionedTableViewState {
    fileprivate var sections: [RoomSection]
    
    init(sections: [RoomSection]) {
        self.sections = sections
    }
}


// MARK: Just extensions to say how to determine identity and how to determine is entity updated

struct RoomSection: AnimatableSectionModelType {
    var header: String
    var rooms: [FirebaseRoom]
    var updated: Date
    
    typealias Item = FirebaseRoom
    typealias Identity = String
    
    init(header: String, rooms: [FirebaseRoom], updated: Date) {
        self.header = header
        self.rooms = rooms
        self.updated = updated
    }
    
    var identity: String {
        return header
    }
    
    var items: [FirebaseRoom] {
        return rooms
    }
    
    init(original: RoomSection, items: [Item]) {
        self = original
        self.rooms = items
    }
}

struct FirebaseRoom: IdentifiableType, Equatable  {
    let roomId: String
    let roomName: String
    let roomDescription: String
    let date: Date
    
    typealias Identity = String
    
    var identity: String {
        return roomId
    }
}

// equatable, this is needed to detect changes
func == (lhs: FirebaseRoom, rhs: FirebaseRoom) -> Bool {
    return lhs.roomId == rhs.roomId && lhs.date == rhs.date
}

// MARK: Some nice extensions
extension FirebaseRoom: CustomDebugStringConvertible {
    var debugDescription: String {
        return "IntItem(number: \(roomName), date: \(date.timeIntervalSince1970))"
    }
}

extension FirebaseRoom: CustomStringConvertible {
    
    var description: String {
        return "\(roomId)"
    }
}

func == (lhs: RoomSection, rhs: RoomSection) -> Bool {
    return lhs.header == rhs.header && lhs.rooms == rhs.rooms && lhs.updated == rhs.updated
}
