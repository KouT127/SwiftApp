//
//  FirebaseChatListRepository.swift
//  SwiftApp
//
//  Created by kou on 2018/11/15.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import FirebaseFirestore

class FirebaseChatListRepository {
    
    private let firestore = Firestore.firestore()
    
    func getInitialData() -> Observable<[FirebaseRoom]> {
        return firestore.collection("rooms").order(by: "date").rx.listen()
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
    
    func getUpdateData() -> Observable<FirebaseRoom?> {
        return firestore.collection("rooms").rx.listen()
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
    
    //TODO:別に置くべきか?
    func initialItem(oldSections: [RoomSection] ,item: [FirebaseRoom], section: Int) -> SectionedTableViewState {
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

}
