//
//  ImageParentTableView.swift
//  SwiftApp
//
//  Created by kou on 2018/12/02.
//  Copyright © 2018 kou. All rights reserved.
//
import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ImageParentTableView: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: ImageCollectionViewModel?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = ImageParentTableViewModel(
            dependency: (
                repository: ImageParentTableRepository(),
                accessor: .shared,
                wireframe: .shared
            )
        )
        
        let nib = UINib(nibName: "TableViewInCollectionCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableViewInCollection")
        
        let dataSource = ImageParentTableView.tableDataSource(delegate: self)
        viewModel.updatedDataSource
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension ImageParentTableView {
    static func tableDataSource<T: UICollectionViewDelegateFlowLayout>(delegate: T) -> RxTableViewSectionedAnimatedDataSource<ParentSection> {
        return RxTableViewSectionedAnimatedDataSource(
            animationConfiguration: AnimationConfiguration(insertAnimation: .top,
                                                           reloadAnimation: .fade,
                                                           deleteAnimation: .left),
            configureCell: { (dataSource, table, idxPath, item) in
                guard let cell = table.dequeueReusableCell(withIdentifier: "TableViewInCollection",for: idxPath) as? ImageParentTableViewCell else { fatalError() }
                
                table.rowHeight = CGFloat(integerLiteral:  300 * idxPath.count)
                
                if let collectionView = cell.collectionView {
                    let dataSource = ImageCollectionView.dataSource()
                    Observable.just(item.imageSection)
                        .bind(to: collectionView.rx.items(dataSource: dataSource))
                        .disposed(by: cell.disposeBag)
                    
                    collectionView.rx.setDelegate(delegate)
                        .disposed(by: cell.disposeBag)
                }
                return cell
        })
    }
    
    static func dataSource() -> RxCollectionViewSectionedAnimatedDataSource<ImageSection> {
        return RxCollectionViewSectionedAnimatedDataSource(animationConfiguration: AnimationConfiguration(insertAnimation: .top,
                                                                                                          reloadAnimation: .fade,
                                                                                                          deleteAnimation: .left),
                                                           configureCell: { (dataSource, collection, idxPath, item)  in
                                                            collection.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
                                                            let cell = collection.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: idxPath) as! ImageCollectionViewCell
                                                            cell.imageView.image = UIImage(named: "Bear")
                                                            cell.userImageView.image = UIImage(named: "Bear")
                                                            cell.userName.text = "Name"
                                                            cell.imageDescription.text = "description"
                                                            return cell
        },
                                                           configureSupplementaryView: {(dataSource, collection, kind, idxPath) in
                                                            collection.register(UINib(nibName: "ImageCollectionKindViewCell", bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: "CollectionSection")
                                                            let section = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionSection", for: idxPath)
                                                            return section
        })
    }
}

extension ImageParentTableView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width * 0.5 - 10
        let height = UIScreen.main.bounds.height * 0.35
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height * 0.05
        return CGSize(width: width, height: height)
    }
}
