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
        
        let url = "https://firebasestorage.googleapis.com/v0/b/practicefirebase-25801.appspot.com/o/user_images%2FTGsLFcRpnKUgKCL0niq84AxJQo13?alt=media&token=b62bf5c1-9ef1-4e9f-b3e1-860ffa27711e"

        let mock = [[url,url], [""],[url, url, url, url, url, url, url]]
        tableView.register(UINib(nibName: "ImageDetailTableSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "SectionHeader")
        
        Observable.just(mock)
            .bind(to: tableView.rx.items) {[unowned self] (table, section, element) in
                if section == 0{
                    return self.createImageSwipeSection(element)
                } else if section == 1{
                    return self.createImageDescriptionSection(element)
                } else if section == 2{
                    return self.createImagesDisplaySection(element)
                }
                return self.createImageSection(element)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
    }
    
    private func createImageSection(_ element: [String]) -> UITableViewCell {
        let imageNib = UINib(nibName: "ImageDetailSectionOne", bundle: nil)
        self.tableView.register(imageNib, forCellReuseIdentifier: "SectionOne")
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "SectionOne") as! ImageDetailSectionOneCell
        cell.postImageDisplay(ImagePipeline.shared.rx.loadImage(with: URL(string: element.first!)!))
        return cell
    }
    
    private func createImagesDisplaySection(_ element: [String]) -> UITableViewCell {
        let section = UINib(nibName: "ImagesDisplaySection", bundle: nil)
        self.tableView.register(section, forCellReuseIdentifier: "ImagesDisplaySectionCell")
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ImagesDisplaySectionCell") as! ImagesDisplaySectionCell
        let layout = UICollectionViewFlowLayout()
        let size = (UIScreen.main.bounds.width - 20) / 2
        layout.itemSize = CGSize(width: size, height: size)
        layout.sectionInset = UIEdgeInsets(top: 0,left: 5,bottom: 5,right: 5)
        layout.minimumInteritemSpacing = 5
        cell.collectionView.collectionViewLayout = layout
        
        Observable.just(element)
            .bind(to: cell.collectionView.rx.items(
                cellIdentifier: "ImagesDisplaySectionCollectionCell",
                cellType: ImagesDisplaySectionCollectionCell.self
            )){(collection, element, cell)  in
                cell.postImageDisplay(ImagePipeline.shared.rx.loadImage(with: URL(string: element)!))
            }
            .disposed(by: cell.disposeBag)
            cell.collectionView.setNeedsLayout()
            cell.collectionView.layoutIfNeeded()
        return cell
    }
    
    private func createImageSwipeSection(_ element: [String]) -> UITableViewCell {
        let section = UINib(nibName: "ImageSwipeSection", bundle: nil)
        self.tableView.register(section, forCellReuseIdentifier: "ImageSwipeSectionCell")
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ImageSwipeSectionCell") as! ImageSwipeSectionCell
        let layout = UICollectionViewFlowLayout()
        let height = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        cell.collectionView.collectionViewLayout = layout
        cell.pageControl.numberOfPages = element.count
        
        cell.collectionView.rx.currentPage
            .subscribe(onNext: {
                cell.pageControl.currentPage = $0
            })
            .disposed(by: cell.disposeBag)
        
        Observable.just(element)
            .bind(to: cell.collectionView.rx.items(
                cellIdentifier: "ImageSwipeSectionCollectionCell",
                cellType: ImageSwipeSectionCollectionCell.self
            )){(collection, element, cell)  in
                cell.imageDisplay(ImagePipeline.shared.rx.loadImage(with: URL(string: element)!))
            }
            .disposed(by: cell.disposeBag)
        cell.collectionView.setNeedsLayout()
        cell.collectionView.layoutIfNeeded()
        return cell
    }
    
    private func createImageDescriptionSection(_ element: [String]) -> UITableViewCell {
        let collectionNib = UINib(nibName: "ImageDescriptionSection", bundle: nil)
        self.tableView.register(collectionNib, forCellReuseIdentifier: "ImageDescriptionSectionCell")
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ImageDescriptionSectionCell") as! ImageDesriptionSection
        cell.imageTitle.text = "タイトル"
        cell.imageDescription.text = "画像の説明〜〜〜〜〜〜〜〜"
        return cell
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
            let height = UIScreen.main.bounds.width
            return height
        } else if indexPath.row == 2{
            //とりあえず固定値
            let height = ((UIScreen.main.bounds.width) / 2) * 4
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
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.statusBarHidden = true
                self.setNeedsStatusBarAppearanceUpdate()
            }, completion: nil)

        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.statusBarHidden = false
                self.setNeedsStatusBarAppearanceUpdate()
            }, completion: nil)
        }
    }
}

fileprivate extension Reactive where Base: UIScrollView {
    fileprivate var currentPage: Observable<Int> {
        return didEndDecelerating.map({
            let pageWidth = self.base.frame.width
            let page = floor((self.base.contentOffset.x - pageWidth / 2) / pageWidth) + 1
            return Int(page)
        })
    }
}
