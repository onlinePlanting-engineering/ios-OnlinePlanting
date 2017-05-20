//
//  OPFarmCommentRepliedTableViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/17/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit
import CoreData

class OPFarmCommentRepliedTableViewController: CoreDataTableViewController {
    
    var farm: Farm?
    var headViewHeight: CGFloat = 0
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var numberBg: UIView!
    @IBOutlet weak var commentcontent: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var replyNumber: UILabel!
    
    var parentComment: FarmComment? {
        didSet {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FarmComment")
            request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
            if let parent = self.parentComment {
                updateHeaderVieDataSource(parent)
                let parentId = parent.id
                request.predicate = NSPredicate(format: "parent == %lld", parentId)
                self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.dataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
                // check has old comments? if yes, hide no comments image
                if let count = self.fetchedResultsController?.sections?[0].numberOfObjects, count == 0 {
                    let _ = noCommentView
                }
            }
        }
    }
    
    lazy var noCommentView: UIImageView = {
        let noCommentView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 64, height: 64))
        noCommentView.image = UIImage.init(named: "no_comments")
        self.tableView.backgroundView?.addSubview(noCommentView)
        noCommentView.translatesAutoresizingMaskIntoConstraints = false
        noCommentView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        noCommentView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        noCommentView.centerXAnchor.constraint(equalTo: (self.tableView.backgroundView?.centerXAnchor)!).isActive = true
        noCommentView.centerYAnchor.constraint(equalTo: (self.tableView.backgroundView?.centerYAnchor)!).isActive = true
        return noCommentView
    }()
    
    func updateHeaderVieDataSource(_ comments: FarmComment){
        numberBg.layer.cornerRadius = 3
        numberBg.layer.masksToBounds = true
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.layer.masksToBounds = true
        guard let content = parentComment else { return }
        commentcontent.text = content.content
        username.text = content.user?.profile?.nickname != "" ? content.user?.profile?.nickname: content.user?.username
        
        let count  = String(content.reply_count)
        if count == "0" {
            numberBg.backgroundColor = UIColor.lightGray
        } else {
            numberBg.backgroundColor = UIColor(hexString: OPGreenColor)
        }
        replyNumber.text = "+\(count)"
        guard let time = content.timestamp else { return }
        timeStamp.text = TimeUtils.timeAgoSinceDate(time, numericDates: false)
        guard let userimageURL = content.user?.profile?.img_heading else { return }
        userImage.sd_setImage(with: URL(string: userimageURL), placeholderImage: UIImage(named: "user_default"))
    }

    
    lazy var commentBottmonView: UIView = {
        let commentBottmonView = OPCommentHereView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 44, width: UIScreen.main.bounds.width, height: 44))
        return commentBottmonView
    }()
    
    lazy var commentInputView: UIView = {
        let commentInputView = OPCommentInputView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 136, width: UIScreen.main.bounds.width, height: 136))
        commentInputView.commentTextView.delegate = self
        return commentInputView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        setNavigarationBar()
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
                guard let commentInput = self?.commentInputView as? OPCommentInputView, let commentHere = self?.commentBottmonView as? OPCommentHereView else { return }
                commentHere.textfield.resignFirstResponder()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.view.addSubview(commentBottmonView)
        self.navigationController?.view.bringSubview(toFront: commentBottmonView)
        
        commentInputView.alpha = 0.0
        self.navigationController?.view.addSubview(commentInputView)
        self.navigationController?.view.bringSubview(toFront: commentInputView)
        
        headerView.frame = CGRect(x: 0, y: 0, width: headerView.frame.width, height: headViewHeight + 5)
        tableView.layoutSubviews()
        
        let footview = UIView()
        tableView.tableFooterView = footview
        tableView.reloadData()
        
        
        
        OPDataService.sharedInstance.getRepliedComment(parentComment?.id) { (success, error) in
            if success {
                print("get data successfully")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        commentBottmonView.removeFromSuperview()
        commentInputView.removeFromSuperview()
    }
    
    func setNavigarationBar() {
        guard let backImage = UIImage(named: "back_white") else { return }
        let leftArrowItem = UIBarButtonItem.createBarButtonItemWithImage(backImage, CGRect(x: 0, y: 0, width: 28, height: 30), self, #selector(dismissCurrentView))
        navigationItem.leftBarButtonItem = leftArrowItem
        
        navigationController?.title = "Detailed Comments"
    }
    
    func dismissCurrentView(){
        let _ = navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OPCommentRepliedTableViewCell", for: indexPath) as! OPCommentRepliedTableViewCell
        guard let comment = fetchedResultsController?.object(at: indexPath) as? FarmComment else { return cell }
        cell.updateDataSource(comment)
        return cell
    }
}

extension OPFarmCommentRepliedTableViewController: OPCommentTextViewDelegate {
    
    func sendMessage(_ message: String?, handler: @escaping (Bool, NSError?) -> Void) {
        OPLoadingHUD.show(UIImage(named: "hud_loading"), title: "Saving comment", animated: true, delay: 0.0)
        guard let id = parentComment?.id else { return }
        OPDataService.sharedInstance.createFarmComment(CommentType.farm.rawValue, object_id: farm?.id, parent_id: id, content: message, grade: "5") {[weak self](success, error) in
            if success {
                handler(true, nil)
                self?.fetchParentObject()
            } else {
                handler(false, error)
                
            }
            OPLoadingHUD.hide()
        }
    }
    
    func saveMessageToContainer(_ message: String?) {
        //
    }
    
    func fetchParentObject() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FarmComment")
        if let parent = self.parentComment {
            let parentId = parent.id
            request.predicate = NSPredicate(format: "id == %lld", parentId)
        }
        let farm = (try! appDelegate.dataStack.mainContext.fetch(request)) as! [FarmComment]
        if farm.count > 0 {
            self.parentComment = farm[0]
            guard let parent = self.parentComment else { return }
            updateHeaderVieDataSource(parent)
        }
    }
}
