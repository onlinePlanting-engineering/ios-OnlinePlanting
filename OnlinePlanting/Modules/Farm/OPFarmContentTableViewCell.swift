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
        
        let height = webView.scrollView.contentSize.height
        var wRect = webView.frame
        wRect.size.height = height
        webView.frame = wRect
    }
}
