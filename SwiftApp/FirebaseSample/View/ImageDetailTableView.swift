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
import Nuke

class ImageDetailTableView: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: ImageCollectionViewModel?
    var statusBarHidden: Bool = false
    
    var headerView : ImageDetailHeaderView!
    
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
        

        let mock = [["https://firebasestorage.googleapis.com/v0/b/practicefirebase-25801.appspot.com/o/user_images%2FTGsLFcRpnKUgKCL0niq84AxJQo13?alt=media&token=b62bf5c1-9ef1-4e9f-b3e1-860ffa27711e"], ["https://firebasestorage.googleapis.com/v0/b/practicefirebase-25801.appspot.com/o/user_images%2Fvje2AHXRsuMHBZi0R6aWqzErwmk1?alt=media&token=0f822cbd-2f97-411d-8099-db99dc287701","https://firebasestorage.googleapis.com/v0/b/practicefirebase-25801.appspot.com/o/user_images%2FTGsLFcRpnKUgKCL0niq84AxJQo13?alt=media&token=b62bf5c1-9ef1-4e9f-b3e1-860ffa27711e"],["https://firebasestorage.googleapis.com/v0/b/practicefirebase-25801.appspot.com/o/user_images%2FTGsLFcRpnKUgKCL0niq84AxJQo13?alt=media&token=b62bf5c1-9ef1-4e9f-b3e1-860ffa27711e","https://firebasestorage.googleapis.com/v0/b/practicefirebase-25801.appspot.com/o/user_images%2FTGsLFcRpnKUgKCL0niq84AxJQo13?alt=media&token=b62bf5c1-9ef1-4e9f-b3e1-860ffa27711e"],["a","a"]]
        
        Observable.just(mock)
            .bind(to: tableView.rx.items) {[unowned self] (table, section, element) in
                if section == 0{
                    let imageNib = UINib(nibName: "ImageDetailSectionOne", bundle: nil)
                    self.tableView.register(imageNib, forCellReuseIdentifier: "SectionOne")
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: "SectionOne") as! ImageDetailSectionOneCell
                    cell.postImageDisplay(ImagePipeline.shared.rx.loadImage(with: URL(string: element.first!)!))
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
                            cell.postImageDisplay(ImagePipeline.shared.rx.loadImage(with: URL(string: element)!))
                            cell.userImageDisplay(ImagePipeline.shared.rx.loadImage(with: URL(string: element)!))
                        }
                        .disposed(by: cell.disposeBag)
                    cell.collectionView.setNeedsLayout()
                    cell.collectionView.layoutIfNeeded()
                    return cell
                } else if section == 2{
                    let sectionTwo = UINib(nibName: "ImageDetailSectionThree", bundle: nil)
                    self.tableView.register(sectionTwo, forCellReuseIdentifier: "SectionThree")
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: "SectionThree") as! ImageDetailSectionThreeCell
                    let layout = UICollectionViewFlowLayout()
                    let height = UIScreen.main.bounds.height * 0.4
                    layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 10, height: height)
                    layout.sectionInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
                    layout.minimumLineSpacing = 0
                    layout.scrollDirection = .horizontal
                    cell.collectionView.collectionViewLayout = layout
                    
                    Observable.just(element)
                        .bind(to: cell.collectionView.rx.items(
                            cellIdentifier: "SectionThreeCollection",
                            cellType: ImageDetailSectionThreeCollectionCell.self
                        )){(collection, element, cell)  in
                            cell.imageDisplay(ImagePipeline.shared.rx.loadImage(with: URL(string: element)!))
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
        
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
    }
    
    private func createImageView() -> ImageDetailHeaderView {
        let height = UIScreen.main.bounds.height / 3
        
        headerView = (Bundle.main.loadNibNamed("ImageDetailHeaderView", owner: self, options: nil)?[0] as? ImageDetailHeaderView)!
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
        headerView.imageView?.image = UIImage(named: "Bear")
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.tableHeaderView = headerView
        return headerView
    }
    
    private func configureTableView() {
        let inputImage = createImageView()
        let height = UIScreen.main.bounds.height / 3
        tableView.tableHeaderView = nil
        tableView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        tableView.addSubview(inputImage)
    }
}

extension ImageDetailTableView {
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

extension ImageDetailTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            let height = UIScreen.main.bounds.height * 0.3
            return height
        } else if indexPath.row == 2 {
            let height = UIScreen.main.bounds.height * 0.3
            return height
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UIScreen.main.bounds.height * 0.35
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(velocity.y > 0) {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                //Navigation等を入れる。
                self.statusBarHidden = true
                self.setNeedsStatusBarAppearanceUpdate()
            }, completion: nil)

        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.statusBarHidden = false
                self.setNeedsStatusBarAppearanceUpdate()
            }, completion: nil)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if headerView != nil {
            //スクロールビューのオフセットを取得
            let yPos: CGFloat = -scrollView.contentOffset.y
            //マイナス値を超えた場合
            //すなわち,表示されたときより上にスクロールしようとした場合
            if yPos > 0 {
                var imgRect: CGRect? = headerView.frame
                //rectのY軸を変更
                imgRect?.origin.y = scrollView.contentOffset.y
                //sizeのは高さを変更
                //ContentInsetのHeight - 画像のサイズ + 縦スクロールした分
                imgRect?.size.height = (UIScreen.main.bounds.height / 3) - (UIScreen.main.bounds.height / 3) + yPos
                headerView.frame = imgRect!
            }
        }
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
