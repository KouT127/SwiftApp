//
//  FirebaseCreateUserView.swift
//  SwiftApp
//
//  Created by kou on 2018/11/19.
//  Copyright © 2018 kou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore
import FirebaseStorage
import RxMediaPicker
import Photos
import FirebaseStorage

class FirebaseUserView: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var profile: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var userImageButton: RoundButton!
    @IBOutlet weak var imageView: RoundImage!
    
    
    var viewModel: FirebaseUserViewModel?
    var picker: RxMediaPicker!
    let db = Firestore.firestore()
    let disposeBag = DisposeBag()
    //ログイン時データベースから取得
    let uid = "fkajsghajdgoi"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = FirebaseUserViewModel(
            input: (
                name: self.name.rx.text.orEmpty.asObservable(),
                profile: self.profile.rx.text.orEmpty.asObservable(),
                updateTaps: self.updateButton.rx.tap.asObservable(),
                imageTaps: self.userImageButton.rx.tap.asObservable()
            ),
            dependency: (
                imagePickerService: ImagePickerService(vc: self),
                repository: FirebaseUserRepository(),
                accessor: .shared,
                wireframe: .shared
            )
        )
        self.viewModel = viewModel
        
        viewModel.updateInfo
            .drive(onNext: {[unowned self] _ in
                self.back()
            })
            .disposed(by: disposeBag)
        
        viewModel.imageInfo
            .drive(onNext: {[unowned self] image in
                self.imageView.image = UIImage(data: image)
                self.imageView.setRounded()
            })
            .disposed(by: disposeBag)
    }
    
    private func back() {
        self.dismiss(animated: true, completion: nil)
    }
}
