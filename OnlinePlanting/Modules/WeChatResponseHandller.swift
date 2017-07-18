
//
//  WeChatResponseHandller.swift
//  SuperAV
//
//  Created by Apple on 5/24/17.
//  Copyright © 2017 dip kasyap dpd.ghimire@gmail.com. All rights reserved.
//

import UIKit
import SwiftyJSON

let paymentBackEndUrl = "http://103.233.58.104/2017/magazine/public/api/v1/create_payment"

enum AlipayStatus {
    case success,userCancelled,failed,pending
}
enum PayMentMethod:String {
    case alipay,wechat
}

enum WeChatPaymentResult {
    case success,failed,userCancelled
}

protocol WeChatResponseHandllerDelegate:class {
    
    func weChatPaymnetDidCompleted(_ result:WeChatPaymentResult,withResponseData response:String?)
    
}
