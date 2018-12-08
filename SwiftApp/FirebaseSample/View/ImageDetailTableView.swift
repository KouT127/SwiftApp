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

class ImageDetailTableView: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: ImageCollectionViewModel?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = ImageDetailTableViewModel(
            dependency: (
                repository: ImageDetailTableRepository(),
                accessor: .shared,
                wireframe: .shared
            )
        )
        

        let mock = [["a"], ["a","b","c","d","e","ff","w"],["s"]]
        
        Observable.just(mock)
            .bind(to: tableView.rx.items) {[unowned self] (table, section, element) in
                if section == 0{
                    let imageNib = UINib(nibName: "ImageDetailSectionOne", bundle: nil)
                    self.tableView.register(imageNib, forCellReuseIdentifier: "SectionOne")
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: "SectionOne") as! ImageDetailSectionOneCell
                    cell.imageView?.image = UIImage(named: "PlaceHolder")
                    return cell
                } else if section == 1{
                    let sectionTwo = UINib(nibName: "ImageDetailSectionTwo", bundle: nil)
                    self.tableView.register(sectionTwo, forCellReuseIdentifier: "SectionTwo")
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: "SectionTwo") as! ImageDetailSectionTwoCell
                    let layout = UICollectionViewFlowLayout()
                    let height = UIScreen.main.bounds.height * 0.35
                    layout.itemSize = CGSize(width:(self.view.frame.width - 20) / 2, height: height)
                    layout.sectionInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
                    layout.minimumInteritemSpacing = 10
                    cell.collectionView.collectionViewLayout = layout

                    Observable.just(element)
                        .bind(to: cell.collectionView.rx.items(
                            cellIdentifier: "SectionTwoCollection",
                            cellType: ImageDetailSectionTwoCollectionCell.self
                        )){(collection, element, cell)  in
//                            cell.imageDescription.text = "aaaaaa"
                        }
                        .disposed(by: cell.disposeBag)
                    cell.collectionView.setNeedsLayout()
                    cell.collectionView.layoutIfNeeded()
                    return cell
                }
                let collectionNib = UINib(nibName: "Card", bundle: nil)
                self.tableView.register(collectionNib, forCellReuseIdentifier: "CardCell")
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "CardCell") as! FirebaseChatListCell
                    cell.imageView?.image = UIImage(named: "PlaceHolder")
                return cell
            }
            .disposed(by: disposeBag)

        
//        let dataSource = ImageParentTableView.tableDataSource(delegate: self)
//        viewModel.updatedDataSource
//            .bind(to: tableView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
//
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
    }
}

//extension ImageParentTableView: UICollectionViewDelegate {
//    static func tableDataSource<T: UICollectionViewDelegateFlowLayout>(delegate: T) -> RxTableViewSectionedAnimatedDataSource<ParentSection> {
//        return RxTableViewSectionedAnimatedDataSource(
//            animationConfiguration: AnimationConfiguration(insertAnimation: .top,
//                                                           reloadAnimation: .fade,
//                                                           deleteAnimation: .left),
//            configureCell: { (dataSource, table, idxPath, item) in
//                guard let cell = table.dequeueReusableCell(withIdentifier: "TableViewInCollection",for: idxPath) as? ImageParentTableViewCell else { fatalError() }
//
//
//                if let collectionView = cell.collectionView {
//                    if idxPath.row == 1 {
//                    let dataSource = ImageCollectionView.dataSource()
//                        Observable.just(item.imageSection)
//                            .bind(to: collectionView.rx.items(dataSource: dataSource))
//                            .disposed(by: cell.disposeBag)
//
//                        collectionView.rx.setDelegate(delegate)
//                            .disposed(by: cell.disposeBag)
//                    }
//
//                }
//                return cell
//        })
//    }
//
//    static func dataSource() -> RxCollectionViewSectionedAnimatedDataSource<ImageSection> {
//        return RxCollectionViewSectionedAnimatedDataSource(animationConfiguration: AnimationConfiguration(insertAnimation: .top,
//                                                                                                          reloadAnimation: .fade,
//                                                                                                          deleteAnimation: .left),
//                                                           configureCell: { (dataSource, collection, idxPath, item)  in
//                                                            collection.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
//                                                            let cell = collection.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: idxPath) as! ImageCollectionViewCell
//                                                            cell.imageView.image = UIImage(named: "Bear")
//                                                            cell.userImageView.image = UIImage(named: "Bear")
//                                                            cell.userName.text = item.userName
//                                                            cell.imageDescription.text = item.description
//                                                            return cell
//        },
//                                                           configureSupplementaryView: {(dataSource, collection, kind, idxPath) in
//                                                            collection.register(UINib(nibName: "ImageCollectionKindViewCell", bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: "CollectionSection")
//                                                            let section = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionSection", for: idxPath)
//                                                            return section
//        })
//    }
//}

//extension ImageParentTableView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = UIScreen.main.bounds.width / 2
//        let height = UIScreen.main.bounds.height * 0.35
//        return CGSize(width: width, height: height)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//
//        let width = UIScreen.main.bounds.width
//        let height = UIScreen.main.bounds.height * 0.05
//        return CGSize(width: width, height: height)
//    }
//
//}

extension ImageDetailTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UIScreen.main.bounds.height * 0.35
    }
}
