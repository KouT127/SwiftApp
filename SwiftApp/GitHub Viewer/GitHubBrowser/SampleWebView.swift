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
        
        var items = [UIBarButtonItem]()
        
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        items.append( UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil ) ) // replace add with your function
        
        self.toolbarItems = items
//        upSwipe.rx.event

        
        let swipeGestureRecog = UISwipeGestureRecognizer(target: self, action: Selector(("swipeGesture")))
        swipeGestureRecog.direction = .down
        self.webView.addGestureRecognizer(swipeGestureRecog)
        swipeGestureRecog.rx.event
            .asObservable()
            .subscribe(onNext: {[unowned self] event in
                self.navigationController?.setToolbarHidden(false, animated: true)
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            })
            .disposed(by: disposeBag)
        
        
//        webView.scrollView.delegate = self
//        webView.scrollView.scrollsToTop = true
//        webView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func swipeGesture(sender: UISwipeGestureRecognizer) {
        
        if sender.direction.contains(.down) {
            print("Right!")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("denit")
    }
}
