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
        return firestore.collection("Posts").order(by: "createdAt").rx.getDocuments()
            .map { value -> [ImageContent] in
                var posts: [ImageContent] = []
                value.documentChanges.forEach { diff in
                    if diff.type == .added {
                        let data = diff.document.data()
                        guard let postImageUrl = data["postImage"] as? String else { return }
                        guard let userImageUrl = data["userImage"] as? String else { return }
                        guard let userName = data["userName"] as? String else { return }
                        guard let postDescription = data["postDescription"] as? String else { return }
                        guard let createdAt = data["createdAt"] as? Date else { return }
//                        guard let updatedAt = data["updatedAt"] as? Date else { return }
                        let id = diff.document.documentID
                        
                        let post: ImageContent = ImageContent(imageId: id, mainImageUrl: postImageUrl, userName: userName, userImageUrl: userImageUrl, imageDescription: postDescription, date: createdAt)
                        posts.append(post)
                    }
                }
                return posts
        }
    }
    
    func getUpdateData() -> Observable<ImageContent?> {
        return firestore.collection("rooms").rx.listen()
            .map { value -> ImageContent? in
                var post: ImageContent?
                value.documentChanges.forEach { diff in
                    if diff.type == .modified {
                        let data = diff.document.data()
                        guard let postImageUrl = data["postImage"] as? String else { return }
                        guard let userImageUrl = data["userImage"] as? String else { return }
                        guard let userName = data["userName"] as? String else { return }
                        guard let postDescription = data["postDescription"] as? String else { return }
                        guard let createdAt = data["createdAt"] as? Date else { return }
                        //                        guard let updatedAt = data["updatedAt"] as? Date else { return }
                        let id = diff.document.documentID
                        post = ImageContent(imageId: id, mainImageUrl: postImageUrl, userName: userName, userImageUrl: userImageUrl, imageDescription: postDescription, date: createdAt)
                    }
                }
                return post
        }
    }
    
    //TODO:別に置くべきか?
    func initialItem(oldSections: [ImageSection] ,item: [ImageContent], section: Int) -> SectionedImageViewState {
        var sections = oldSections
        let items = sections[section].items + item
        sections[section] = ImageSection(original: sections[section], items: items)
        return SectionedImageViewState(sections: sections)
    }
    
    func addItem(oldSections: [ImageSection] ,item: ImageContent, section: Int) -> SectionedImageViewState {
        var sections = oldSections
        let items = sections[section].items + item
        sections[section] = ImageSection(original: sections[section], items: items)
        return SectionedImageViewState(sections: sections)
    }
    
    func deleteItem(oldSections: [ImageSection], index: IndexPath) -> SectionedImageViewState {
        var sections = oldSections
        var items = sections[index.section].items
        items.remove(at: index.row)
        sections[index.section] = ImageSection(original: sections[index.section], items: items)
        return SectionedImageViewState(sections: sections)
    }
}
