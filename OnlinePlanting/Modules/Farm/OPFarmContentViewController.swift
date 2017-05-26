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
    @IBOutlet weak var iNeedRent: UIButton!
    @IBOutlet weak var farmAlbum: UIButton!
    var currentScrollOffSet: CGFloat = 0
    fileprivate var albumVC: OPFarmAlbumCollectionViewController?
    fileprivate var noticeVC: OPFarmRendNoticeViewController?
    fileprivate var landVC: OPLandViewController?
    
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

        delegate?.previousPage(currentScrollOffSet)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        loadingIndicator.stopAnimating()
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
