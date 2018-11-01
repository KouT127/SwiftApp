//
//  sampleWebView.swift
//  SwiftApp
//
//  Created by kou on 2018/10/29.
//  Copyright © 2018 kou. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import AMScrollingNavbar

class SampleWebView: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var upSwipe: UISwipeGestureRecognizer!
    
    let backButton = UIBarButtonItem(image: UIImage(named: "BackButton"), style: .done, target: self, action: nil)
    let nextButton = UIBarButtonItem(image: UIImage(named: "NextButton"), style: .done, target: self, action: nil)
    let fixed = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
    let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    
    var url: String = ""
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setUpToolBar()
    }
    
    private func setUpToolBar() {
        fixed.width = 20
        self.toolbarItems = [backButton, fixed, nextButton, flexible]
        
        nextButton.isEnabled = false
        backButton.isEnabled = false
        
        backButton.rx.tap
            .asDriver()
            .drive(onNext: {[unowned self] tap in
                self.webView.goBack()
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .asDriver()
            .drive(onNext: {[unowned self] tap in
                self.webView.goForward()
            })
            .disposed(by: disposeBag)
    }
        
    private func setupWebView() {
        
        let loadingObservable = webView.rx.loading.share()
        
        loadingObservable
            .map { !$0 }
            .observeOn(MainScheduler.instance)
            .bind(to: progressView.rx.isHidden)
            .disposed(by: disposeBag)
        
        // NavigationControllerのタイトル表示
        loadingObservable
            .map { [unowned self] _ in return self.webView.title }
            .observeOn(MainScheduler.instance)
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        // プログレスバーのゲージ制御
        webView.rx.estimatedProgress
            .observeOn(MainScheduler.instance)
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)
        
        webView.rx.canGoForward
            .observeOn(MainScheduler.instance)
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        webView.rx.canGoBack
            .observeOn(MainScheduler.instance)
            .bind(to: backButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
        let url = URL(string: self.url)
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.hidesBarsOnSwipe = true
        tabBarItem.isEnabled = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tabBarItem.isEnabled = false
        tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("denit")
    }
}
