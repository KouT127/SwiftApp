//
//  ImageDetail.swift
//  SwiftApp
//
//  Created by kou on 2018/12/06.
//  Copyright © 2018 kou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Nuke

class ImageDetailView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var mock: [ImageSection] = []
    
    override func viewDidLoad() {
        
        mock = [ImageSection(header: "header",
                            contents: [ImageContent(imageId: "1",
                                                    mainImageUrl: "https://firebasestorage.googleapis.com/v0/b/practicefirebase-25801.appspot.com/o/user_images%2FTGsLFcRpnKUgKCL0niq84AxJQo13?alt=media&token=b62bf5c1-9ef1-4e9f-b3e1-860ffa27711e",
                                                    userName: "",
                                                    userImageUrl: "",
                                                    imageDescription: "",
                                                    date: Date())],
                            updated: Date())]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let cell = UINib(nibName: "ImageDetailSectionOne", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "SectionOneCell")
    }
}

extension ImageDetailView:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mock.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? ImageDetailSectionOneCell else { return }
        
        //ShopTableViewCell.swiftで設定したメソッドを呼び出す
//        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionOneCell", for: indexPath) as! ImageDetailSectionOneCell
        let url = URL(string: (mock[indexPath.row].contents.first?.mainImageUrl)!)!
        cell.imageView?.image = UIImage(contentsOfFile: "Bear")
        Nuke.loadImage(with: url, into: cell.imageView!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(0)
    }
    
}


//extension ImageDetailView: UICollectionViewDataSource, UICollectionViewDelegate{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionOneCell", for: indexPath) as! ImageDetailSectionOneCell
//
//        cell.imageView?.image =
//
//    }
//}
