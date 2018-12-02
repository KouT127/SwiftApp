//
//  ImageParentTableRepository.swift
//  SwiftApp
//
//  Created by kou on 2018/12/02.
//  Copyright © 2018 kou. All rights reserved.
//
import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import FirebaseFirestore

class ImageParentTableRepository {
    
    private let firestore = Firestore.firestore()
    
    var mockData = [ImageSection(header: "List", contents: [], updated: Date())]
    
    func getInitialData() -> Observable<[Content]> {
        return firestore.collection("rooms").order(by: "date").rx.getDocuments()
            .map { value -> [Content] in
                var rooms: [Content] = []
                value.documentChanges.forEach { diff in
                    if diff.type == .added {
                        let data = diff.document.data()
                        //                        guard let roomName = data["roomName"] as? String else { return }
                        //                        guard let roomDescription = data["roomDescription"] as? String else { return }
                        guard let date = data["date"] as? Date else { return }
                        let roomId =  diff.document.documentID
                        let room = Content(contentId: "aa", headerSection: [], imageSection: [], date: Date())
                        rooms.append(room)
                    }
                }
                return rooms
        }
    }
    
    func getUpdateData() -> Observable<Content?> {
        return firestore.collection("rooms").rx.listen()
            .map { value -> Content? in
                var room: Content?
                value.documentChanges.forEach { diff in
                    if diff.type == .modified {
                        let data = diff.document.data()
                        //                        guard let roomName = data["roomName"] as? String else { return }
                        //                        guard let roomDescription = data["roomDescription"] as? String else { return }
                        guard let date = data["date"] as? Date else { return }
                        let roomId =  diff.document.documentID
                        room = Content(contentId: "aa", headerSection: [], imageSection: [], date: Date())
                    }
                }
                return room
        }
    }
    
    //TODO:別に置くべきか?
    func initialItem(oldSections: [ParentSection] ,item: [Content], section: Int) -> SectionedParentViewState {
        var sections = oldSections
        let items = sections[section].contents + item
        sections[section] = ParentSection(original: sections[section], items: items)
        return SectionedParentViewState(sections: sections)
    }
    
    func addItem(oldSections: [ParentSection] ,item: Content, section: Int) -> SectionedParentViewState {
        var sections = oldSections
        let items = sections[section].contents + item
        sections[section] = ParentSection(original: sections[section], items: items)
        return SectionedParentViewState(sections: sections)
    }
    
    func deleteItem(oldSections: [ParentSection], index: IndexPath) -> SectionedParentViewState {
        var sections = oldSections
        print(index.section)
        var items = sections[index.section].items
        print(items)
        items.remove(at: index.row)
        sections[index.section] = ParentSection(original: sections[index.section], items: items)
        return SectionedParentViewState(sections: sections)
    }
}
