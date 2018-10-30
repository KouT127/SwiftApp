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

class SampleWebView: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    var url: String = ""
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        
    }
        
    private func setupWebView() {
        
        let loadingObservable = webView.rx.observe(Bool.self, "loading")
            .flatMap { $0.flatMap { Observable.just($0) } ?? Observable.empty() }
            .share()
        
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
        webView.rx.observe(Double.self, "estimatedProgress")
            .flatMap { $0.flatMap { Observable.just($0) } ?? Observable.empty() }
            .map { return Float($0) }
            .observeOn(MainScheduler.instance)
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)
        
        let url = URL(string: self.url)
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
        
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        
        
//        webView.scrollView.delegate = self
//        webView.scrollView.scrollsToTop = true
//        webView.translatesAutoresizingMaskIntoConstraints = false
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if let navigationController = navigationController as? ScrollingNavigationController {
//            navigationController.followScrollView(webView, delay: 50.0)
//        }
//    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: true)
//        if let navigationController = navigationController as? ScrollingNavigationController {
//            navigationController.stopFollowingScrollView()
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("denit")
    }
}
