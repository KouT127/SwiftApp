//
//  ImageCollectionRepository.swift
//  SwiftApp
//
//  Created by kou on 2018/12/01.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import FirebaseFirestore

class ImageCollectionRepository {
    
    private let firestore = Firestore.firestore()
    
    func getInitialData() -> Observable<[ImageContent]> {
        return firestore.collection("rooms").order(by: "date").rx.getDocuments()
            .map { value -> [ImageContent] in
                var rooms: [ImageContent] = []
                value.documentChanges.forEach { diff in
                    if diff.type == .added {
                        let data = diff.document.data()
//                        guard let roomName = data["roomName"] as? String else { return }
//                        guard let roomDescription = data["roomDescription"] as? String else { return }
                        guard let date = data["date"] as? Date else { return }
                        let roomId =  diff.document.documentID
                        let room: ImageContent = ImageContent(contentId: "a", mainImageUrl: "b", userName: "c", userImageUrl: "d", imageDescription: "e", date: date)
                        rooms.append(room)
                    }
                }
                return rooms
        }
    }
    
    func getUpdateData() -> Observable<ImageContent?> {
        return firestore.collection("rooms").rx.listen()
            .map { value -> ImageContent? in
                var room: ImageContent?
                value.documentChanges.forEach { diff in
                    if diff.type == .modified {
                        let data = diff.document.data()
//                        guard let roomName = data["roomName"] as? String else { return }
//                        guard let roomDescription = data["roomDescription"] as? String else { return }
                        guard let date = data["date"] as? Date else { return }
                        let roomId =  diff.document.documentID
                        room = ImageContent(contentId: "a", mainImageUrl: "b", userName: "c", userImageUrl: "d", imageDescription: "e", date: date)
                    }
                }
                return room
        }
    }
    
    //TODO:別に置くべきか?
    func initialItem(oldSections: [ImageSection] ,item: [ImageContent], section: Int) -> SectionedCollectionViewState {
        var sections = oldSections
        let items = sections[section].items + item
        sections[section] = ImageSection(original: sections[section], items: items)
        return SectionedCollectionViewState(sections: sections)
    }
    
    func addItem(oldSections: [ImageSection] ,item: ImageContent, section: Int) -> SectionedCollectionViewState {
        var sections = oldSections
        let items = sections[section].items + item
        sections[section] = ImageSection(original: sections[section], items: items)
        return SectionedCollectionViewState(sections: sections)
    }
    
    func deleteItem(oldSections: [ImageSection], index: IndexPath) -> SectionedCollectionViewState {
        var sections = oldSections
        print(index.section)
        var items = sections[index.section].items
        print(items)
        items.remove(at: index.row)
        sections[index.section] = ImageSection(original: sections[index.section], items: items)
        return SectionedCollectionViewState(sections: sections)
    }
}
