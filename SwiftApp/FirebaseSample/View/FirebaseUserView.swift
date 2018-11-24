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

class FirebaseUserView: UIViewController, RxMediaPickerDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var profile: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var userImageButton: RoundButton!
    
    
    var viewModel: FirebaseUserViewModel?
    var picker: RxMediaPicker!
    let db = Firestore.firestore()
    let disposeBag = DisposeBag()
    //ログイン時データベースから取得
    let uid = "fkajsghajdgoi"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker()
        
        let image = userImageButton.rx.tap
            .asObservable()
            .debug()
            .flatMap {self.pickPhoto()}
            .map{ $1?.jpegData(compressionQuality: 0.8)}
            .filterNil()
        
        let viewModel = FirebaseUserViewModel(
            input: (
                name: self.name.rx.text.orEmpty.asObservable(),
                profile: self.profile.rx.text.orEmpty.asObservable(),
                updateTaps: self.updateButton.rx.tap.asObservable(),
                image: image
            ),
            dependency: (
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
    }
    
    private func imagePicker(){
        picker = RxMediaPicker(delegate: self)
    }
    
    private func pickPhoto() -> Observable<(UIImage, UIImage?)>{
        return picker.selectImage(editable: true)
    }
    
    //DelegateMethod
    func present(picker: UIImagePickerController) {
        present(picker, animated: true, completion: nil)
    }
    func dismiss(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func back() {
        self.dismiss(animated: true, completion: nil)
    }

}
