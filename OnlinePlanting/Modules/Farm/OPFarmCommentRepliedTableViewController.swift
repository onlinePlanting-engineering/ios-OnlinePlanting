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
    fileprivate var replyAlertController: UIAlertController?
    
    var parentComment: FarmComment? {
        didSet {
            if let parent = self.parentComment {
                updateHeaderVieDataSource(parent)
                
                let preRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FarmComment")
                preRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
                preRequest.predicate = NSPredicate(format: "parent.id == %lld", parent.id)
                let farmcomments = (try! appDelegate.dataStack.mainContext.fetch(preRequest)) as! [FarmComment]
                //print("farm information is: \(farm[0].content)")
                var tempArray = [Int64]()
                if farmcomments.count > 0 {
                    for farmcomment in farmcomments {
                        tempArray.append(farmcomment.id)
                    }
                }
                
                for id in tempArray {
                    let preRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FarmComment")
                    preRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
                    preRequest.predicate = NSPredicate(format: "parent.id == %lld", id)
                    let childcomments = (try! appDelegate.dataStack.mainContext.fetch(preRequest)) as! [FarmComment]
                    if childcomments.count > 0 {
                        for childcomment in childcomments {
                            tempArray.append(childcomment.id)
                        }
                    }
                }
                
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FarmComment")
                request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
                request.predicate = NSPredicate(format:"parent == %lld OR parent IN %@",parent.id, tempArray)
                self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.dataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
                
                if let count = self.fetchedResultsController?.fetchedObjects?.count, count == 0 {
                    let _ = noCommentView
                }
            }
        }
    }
    
    lazy var maskView: UIView = {
        let maskView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        maskView.backgroundColor = UIColor.black
        maskView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeCommentInputView))
        maskView.addGestureRecognizer(gesture)
        maskView.alpha = 0.55
        return maskView
    }()
    
    func closeCommentInputView() {
        maskView.isHidden = true
        let commentView = (commentInputView as? OPCommentInputView)?.commentTextView.customTextView
        commentView?.resignFirstResponder()
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
//                guard let commentInput = self?.commentInputView as? OPCommentInputView else { return }
//                commentInput.commentTextView.customTextView.becomeFirstResponder()
            })
        }
    }
    
    func keyBoardWillHide(_ notification: Notification){
        maskView.isHidden = true
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.commentInputView.alpha = 0.0
            self?.commentInputView.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height  - 136, width: UIScreen.main.bounds.width, height: 136)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        maskView.isHidden = true
        navigationController?.view.addSubview(maskView)
        
        commentInputView.alpha = 0.0
        maskView.isHidden = true
        navigationController?.view.addSubview(maskView)
        navigationController?.view.addSubview(commentInputView)
        navigationController?.view.bringSubview(toFront: commentInputView)
        
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
        noCommentView.removeFromSuperview()
        guard let comment = fetchedResultsController?.object(at: indexPath) as? FarmComment else { return cell }
        let parent = fetchDetailedParentComment(comment.parent)
        if parent?.id == parentComment?.id {
            cell.updateDataSource(comment, nil)
        } else {
            cell.updateDataSource(comment, parent)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let parent = fetchedResultsController?.object(at: indexPath) as? FarmComment
        if parent?.user?.username == appDelegate.currentUser?.username {
            guard let alterVC = showReplyAlertController(parentComment?.id, showDelete: true, commentId: parent?.id) else { return }
            present(alterVC, animated: true, completion: nil)
        } else {
            guard let alterVC = showReplyAlertController(parent?.id) else { return }
            present(alterVC, animated: true, completion: nil)
        }
    }
    
    func fetchDetailedParentComment(_ parentId: Int64?) -> FarmComment? {
        guard let parent = parentId else { return nil }
        let preRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FarmComment")
        preRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        preRequest.predicate = NSPredicate(format: "id == %lld", parent)
        let farmcomments = (try! appDelegate.dataStack.mainContext.fetch(preRequest)) as! [FarmComment]
        if farmcomments.count > 0 {
            return farmcomments[0]
        }
        return nil
    }
    
    func showCommentView(_ parentId: Int64?) {
        maskView.isHidden = false
        let commentView = (commentInputView as? OPCommentInputView)?.commentTextView
        commentView?.parentId = parentId
        commentView?.customTextView.becomeFirstResponder()
    }
    
    func deleteComment(_ commentId: Int64?, parentId: Int64?) {
        OPLoadingHUD.show(UIImage(named: "hud_loading"), title: "Deleting", animated: true, delay: 0.0)
        OPDataService.sharedInstance.deleteComment(commentId, parentId: parentId) { (success, error) in
            if success {
                print("delete successfully")
            } else {
                print("delete failed")
            }
            OPLoadingHUD.hide()
        }
    }
}

extension OPFarmCommentRepliedTableViewController: OPCommentTextViewDelegate {
    
    func sendMessage(_ message: String?, parent: Int64?, handler: @escaping (Bool, NSError?) -> Void) {
        OPLoadingHUD.show(UIImage(named: "hud_loading"), title: "Saving comment", animated: true, delay: 0.0)
        guard let id = parent else { return }
        OPDataService.sharedInstance.createFarmComment(CommentType.farm.rawValue, object_id: farm?.id, parent_id: id, content: message, grade: "5") {[weak self](success, error) in
            if success {
                handler(true, nil)
                self?.closeCommentInputView()
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
    
    func showReplyAlertController(_ parentId: Int64?, showDelete: Bool = false, commentId: Int64? = nil) -> UIAlertController? {
        replyAlertController = nil
        
        replyAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        replyAlertController?.view.tintColor = UIColor(hexString: OPGreenColor)
        let replyAction = UIAlertAction(title: "回复", style: .default, handler: { [weak self] (action) in
            self?.showCommentView(parentId)
        })
        replyAlertController?.addAction(replyAction)
        
        if showDelete {
            let deleteAction = UIAlertAction(title: "删除回复", style: .default, handler: { [weak self] (action) in
                self?.deleteComment(commentId, parentId: parentId)
            })
            replyAlertController?.addAction(deleteAction)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            //self?.actionPhotoAction(action)
        })
        replyAlertController?.addAction(cancelAction)
        return replyAlertController
    }
}
