//
//  OPFarmContentViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/9/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPFarmContentViewController: UIViewController {
    
    var farm: Farm?
    weak var delegate: SubScrollDelegate?
    @IBOutlet weak var farmScrollView: UIScrollView!
    @IBOutlet weak var farmContentWebview: UIWebView!
    @IBOutlet weak var webviewheight: NSLayoutConstraint!
    @IBOutlet weak var loadingIndicator: OPLoadingIndicator!
    fileprivate var currentScrollView: UIScrollView?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.startAnimating()
        guard let contentURL = farm?.content, let url = URL(string: contentURL) else { return }
        farmContentWebview.loadRequest(URLRequest(url: url))
        
        prepareUI()
    }
    
    func prepareUI() {
        farmContentWebview.scrollView.showsVerticalScrollIndicator = false
        farmContentWebview.scrollView.showsHorizontalScrollIndicator = false
        farmContentWebview.scrollView.isScrollEnabled = false
        farmContentWebview.delegate = self
        farmScrollView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.currentScrollView?.contentOffset.y = 0
        }
    }
}

extension OPFarmContentViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentScrollView = scrollView
        delegate?.customScrollViewDidScroll(scrollView)
    }
}

extension OPFarmContentViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadingIndicator.stopAnimating()
        let contentHeight = webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight")
        if let content = contentHeight, let webviewHegith = NumberFormatter().number(from: content){
            print("Webview height is::\(contentHeight)")
            if CGFloat(webviewHegith) > view.bounds.height {
                webviewheight.constant = CGFloat(webviewHegith) - view.bounds.height
                view.layoutIfNeeded()
            }
        }

    }
}
