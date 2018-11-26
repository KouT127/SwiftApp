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
import SVProgressHUD

class FirebaseUserView: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var profile: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var userImageButton: RoundButton!
    @IBOutlet weak var imageView: RoundImage!
    
    var viewModel: FirebaseUserViewModel?
    var picker: RxMediaPicker!
    let db = Firestore.firestore()
    var loadingView: UIView!
    let disposeBag = DisposeBag()
    
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
        
        viewModel.currentUserInfo
            .drive(onNext: {[unowned self] user in
                if let image = user.image {
                    self.imageView.image = UIImage(data: image)
                } else {
                    self.imageView.image = UIImage(named: "Bear")
                }
                self.name.text = user.name
                self.profile.text = user.profile
            })
            .disposed(by: disposeBag)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIInit()
        
        viewModel?.network
            .emit(onNext: {[unowned self] network in

                network ? SVProgressHUD.show() : SVProgressHUD.dismiss()
                self.loadingView.isHidden = !network
            })
            .disposed(by: disposeBag)
    }
    
    private func UIInit() {
        loadingView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        self.view.addSubview(loadingView)
        self.loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.loadingView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loadingView.backgroundColor = UIColor.black
        loadingView.alpha = 0.3
        loadingView.isHidden = true
    }
    
    private func back() {
        self.navigationController?.popViewController(animated: true)
    }
}
