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

struct SectionedTableViewState {
    var sections: [RoomSection]
    init(sections: [RoomSection]) {
        self.sections = sections
    }
}

//Section
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

//Section内の内容
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
