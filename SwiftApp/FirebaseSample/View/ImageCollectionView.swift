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

class ImageCollectionView: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = ImageCollectionViewModel(
            dependency: (
                repository: ImageCollectionRepository(),
                accessor: .shared,
                wireframe: .shared
            )
        )
        
        let dataSource = ImageCollectionView.dataSource()
        viewModel.updatedDataSource
            .bind(to: mainCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        mainCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
    }

}

extension ImageCollectionView {
    static func dataSource() -> RxCollectionViewSectionedAnimatedDataSource<ImageSection> {
        return RxCollectionViewSectionedAnimatedDataSource(animationConfiguration: AnimationConfiguration(insertAnimation: .top,
                                                                   reloadAnimation: .fade,
                                                                   deleteAnimation: .left),
                configureCell: { (dataSource, collection, idxPath, item)  in
                    collection.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
                    let cell = collection.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: idxPath) as! ImageCollectionViewCell
//                    cell.imageView.image = UIImage(named: "Bear")
//                    cell.userImageView.image = UIImage(named: "Bear")
//                    cell.userName.text = "Name"
//                    cell.imageDescription.text = "description"
                    return cell
                },
                configureSupplementaryView: {(dataSource, collection, kind, idxPath) in
                    collection.register(UINib(nibName: "ImageCollectionKindViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionSection")
                    let section = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionSection", for: idxPath)
                    return section
                })
    }
}
