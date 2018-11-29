//
//  ImageCollectionView.swift
//  SwiftApp
//
//  Created by kou on 2018/11/29.
//  Copyright © 2018 kou. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ImageCollectionView: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = ImageCollectionView.dataSource()

        
    }

}

extension ImageCollectionView {
    static func dataSource() -> RxCollectionViewSectionedAnimatedDataSource<RoomSection> {
        return RxCollectionViewSectionedAnimatedDataSource(animationConfiguration: AnimationConfiguration(insertAnimation: .top,
                                                                   reloadAnimation: .fade,
                                                                   deleteAnimation: .left),
                configureCell: { (dataSource, collection, idxPath, item)  in
                    let cell = collection.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: idxPath) as! CollectionViewCell
                    cell.imageView.image = UIImage(named: "Bear")
                    cell.userImageView.image = UIImage(named: "Bear")
                    cell.userName.text = "Name"
                    cell.imageDescription.text = "description"
                    return cell
                })
    }
}
