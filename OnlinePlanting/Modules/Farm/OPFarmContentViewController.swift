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
    @IBOutlet weak var failedRefreshView: UIView!
    
    
    var currentScrollOffSet: CGFloat = 0
    fileprivate var albumVC: OPFarmAlbumCollectionViewController?
    fileprivate var noticeVC: OPFarmRendNoticeViewController?
    fileprivate var landVC: OPLandViewController?
    fileprivate var isLoading = false
    
    fileprivate var loadSuccess = false {
        didSet {
            loadingIndicator.isHidden = true
            loadingIndicator.stopAnimating()
            isLoading = false
            if loadSuccess {
                return
            } else {
                failedRefreshView.isHidden = false
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
    }
    
    func prepareUI() {
        farmContentWebview.scrollView.showsVerticalScrollIndicator = false
        farmContentWebview.scrollView.showsHorizontalScrollIndicator = false
        farmContentWebview.scrollView.isScrollEnabled = false
        farmContentWebview.delegate = self
        farmScrollView.delegate = self
        
        failedRefreshView.isHidden = true
        loadingIndicator.isHidden = true
        
        startLoadingContent()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isLoading {
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
            
        }
        delegate?.previousPage(currentScrollOffSet)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isLoading {
            loadingIndicator.isHidden = true
            loadingIndicator.stopAnimating()
        }
        
    }
    
    
    @IBAction func refreshButton(_ sender: UIButton) {
        startLoadingContent()
    }
    
    @IBAction func showFarmAlbum(_ sender: UIButton) {
        albumVC = UIStoryboard(name: "OPFarm", bundle: nil).instantiateViewController(withIdentifier: "OPFarmAlbumCollectionViewController") as? OPFarmAlbumCollectionViewController
        albumVC?.currentFarm = farm
        guard let album = albumVC else { return }
        navigationController?.pushViewController(album, animated: true)
    }
    
    @IBAction func showLand(_ sender: UIButton) {
        landVC = UIStoryboard(name: "OPFarm", bundle: nil).instantiateViewController(withIdentifier: "OPLandViewController") as? OPLandViewController
        guard let lands = landVC else { return }
        navigationController?.pushViewController(lands, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OPFarmRendNoticeViewController" {
            noticeVC = (segue.destination as? UINavigationController)?.childViewControllers.first as? OPFarmRendNoticeViewController
            noticeVC?.farm = farm
        }
    }
    
    func startLoadingContent(){
        isLoading = true
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        failedRefreshView.isHidden = true
        guard let contentURL = farm?.content, let url = URL(string: contentURL) else { return }
        farmContentWebview.loadRequest(URLRequest(url: url))
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            if let load = self?.loadSuccess, load == true {
                return
            } else {
                self?.loadSuccess = false
            }
        }
    }
    
}

extension OPFarmContentViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentScrollOffSet = scrollView.contentOffset.y
        delegate?.customScrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.hideOrShowBottomViewBeginScroll(scrollView)
    }
}

extension OPFarmContentViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadSuccess = true
        let contentHeight = webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight")
        if let content = contentHeight, let webviewHegith = NumberFormatter().number(from: content){
            //print("Webview height is::\(contentHeight)")
            if CGFloat(webviewHegith) > view.bounds.height {
                webviewheight.constant = CGFloat(webviewHegith) - view.bounds.height
                view.layoutIfNeeded()
            }
        }

    }
}
