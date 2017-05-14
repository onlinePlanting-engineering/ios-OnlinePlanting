//
//  OPFarmContentTableViewCell.swift
//  OnlinePlanting
//
//  Created by IBM on 5/9/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPFarmContentTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var farmContentWebView: UIWebView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        farmContentWebView.scrollView.showsVerticalScrollIndicator = false
        farmContentWebView.scrollView.showsHorizontalScrollIndicator = false
        farmContentWebView.delegate = self
        farmContentWebView.scrollView.isScrollEnabled = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateDataSource(_ farm: Farm?) {
        guard let contentURL = farm?.content, let url = URL(string: contentURL) else { return }
        farmContentWebView.loadRequest(URLRequest(url: url))
    }
}

extension OPFarmContentTableViewCell: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let contentHeight = webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight")
        print("Webview height is::\(contentHeight)")
//        if let content = contentHeight, let webviewHegith = NumberFormatter().number(from: content){
//            
//            let height = CGFloat(webviewHegith)
//            let fittingSize = webView.sizeThatFits(CGSize.init(width: self.frame.width, height: height))
//            frame.size.height = fittingSize.height
//            webView.frame = CGRect(x: 0, y: 0, width: fittingSize.width, height: fittingSize.height)
//            
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FarmContentHeight"), object: nil, userInfo: nil)
//
//        }
        
    }
}
