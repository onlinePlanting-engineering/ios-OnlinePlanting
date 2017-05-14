//
//  OPFarmCommentViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/12/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPFarmCommentViewController: CoreDataTableViewController {
    
    
    @IBOutlet var tableViewReference: UITableView!
    weak var delegate: SubScrollDelegate?
    var backgroundView: UIView?
    var currentScrollView: UIScrollView?
    
    lazy var commentBottmonView: UIView = {
        let commentBottmonView = OPCommentHereView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 44, width: UIScreen.main.bounds.width, height: 44))
        return commentBottmonView
    }()
    
    lazy var commentInputView: UIView = {
        let commentInputView = OPCommentInputView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 136, width: UIScreen.main.bounds.width, height: 136))
        return commentInputView
    }()
    
    lazy var backgroundImage: UIImageView = {
        let backgroundImage = UIImageView()
        let image = UIImage.init(named: "login_background")
        backgroundImage.image = image
        backgroundImage.frame = self.tableView.bounds
        self.backgroundView?.addSubview(backgroundImage)
        return backgroundImage
    }()
    
    lazy var effectiveView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let effectiveView = UIVisualEffectView(effect: blurEffect)
        effectiveView.contentView.backgroundColor = UIColor.black
        effectiveView.contentView.alpha = 0.35
        self.backgroundView?.addSubview(effectiveView)
        effectiveView.frame = self.tableView.bounds
        return effectiveView
    }()
    
    let commentData = ["如果对大家有帮助我很荣幸、有什么问题可以留言、有什么错误也可以留言提醒、感谢","have you tried implementing this delegate method: func tabl","动态计算文本高度！这里有一点说明一下、计算文本的方法提示打不出来、只有自己硬打出来！方法返回的类型是CGRect、可以自己看一下","tableview默认是不支持cell有间隔的，让美工把cell的背景图片切成有一段是透明的。也就是感觉上是有间隔的，但实际上cell还是连着的。或者做两个cell，其中一个是透明的cell。简单点直接设置tableview的类型为group ，设置各个区块的间隔。"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func prepareUI() {
        
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        backgroundView?.backgroundColor = UIColor.orange
        let _ = backgroundImage
        let _ = effectiveView
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundView = backgroundView
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let commentInput = commentInputView as? OPCommentInputView else { return }
        commentInput.commentTextView.customTextView.resignFirstResponder()
    }
    
    func keyBoardWillShow(_ notification: Notification){
        var offset: CGFloat = 0
        let userInfo  = notification.userInfo
        let  keyBoardFrame = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardOriginY = keyBoardFrame.origin.y
        if let windowsHeight = appDelegate.window?.frame.size.height {
            if windowsHeight - keyBoardFrame.height < keyboardOriginY {
                offset = windowsHeight - keyboardOriginY
            } else {
                offset = keyBoardFrame.height
            }
        }
        if let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            UIView.animate(withDuration: duration, animations: { [weak self] in
                self?.commentInputView.alpha = 1.0
                self?.commentInputView.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height - offset - 136, width: UIScreen.main.bounds.width, height: 136)
                guard let commentInput = self?.commentInputView as? OPCommentInputView else { return }
                commentInput.commentTextView.customTextView.becomeFirstResponder()
            })
        }

    }
    
    func keyBoardWillHide(_ notification: Notification){
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.commentInputView.alpha = 0.0
            self?.commentInputView.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height  - 136, width: UIScreen.main.bounds.width, height: 136)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.view.addSubview(commentBottmonView)
        self.navigationController?.view.bringSubview(toFront: commentBottmonView)
        
        self.navigationController?.view.addSubview(commentInputView)
        self.navigationController?.view.bringSubview(toFront: commentInputView)
        commentInputView.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.currentScrollView?.contentOffset.y = 0
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        commentBottmonView.removeFromSuperview()
        commentInputView.removeFromSuperview()
    }
}

extension OPFarmCommentViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OPComentTableViewCell", for: indexPath) as! OPComentTableViewCell
        cell.commentContent.text = commentData[indexPath.row]
        return cell
    }
}

extension OPFarmCommentViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentScrollView = scrollView
        delegate?.customScrollViewDidScroll(scrollView)
    }
}




