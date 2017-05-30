//
//  OPFarmCommentViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/12/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit
import CoreData


class OPFarmCommentViewController: CoreDataTableViewController {
    
    var farm: Farm?
    @IBOutlet var tableViewReference: UITableView!
    weak var delegate: SubScrollDelegate?
    var currentScrollOffSet: CGFloat = 0
    fileprivate var replyAlertController: UIAlertController?
    fileprivate var parentComment: Comment?
    fileprivate var parentCellHeight: CGFloat?
    
    lazy var oploadingView: OPLoadingIndicator = {
        let oploadingView = OPLoadingIndicator.init(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 270, width: 96, height: 70))
        oploadingView.image = UIImage(named: "hud_loading")
        oploadingView.titleView.text = "Loading"
        oploadingView.titleView.textColor = UIColor.white
        oploadingView.alpha = 0.75
        oploadingView.center.x = self.tableView.center.x
        return oploadingView
    }()
    
    lazy var noCommentView: UIImageView = {
        let noCommentView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        noCommentView.image = UIImage(named: "load_failed")
        self.tableView.backgroundView?.addSubview(noCommentView)
        noCommentView.translatesAutoresizingMaskIntoConstraints = false
        noCommentView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        noCommentView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        noCommentView.centerXAnchor.constraint(equalTo: (self.tableView.backgroundView?.centerXAnchor)!).isActive = true
        noCommentView.bottomAnchor.constraint(equalTo: (self.tableView.backgroundView?.bottomAnchor)!, constant: -200).isActive = true
        return noCommentView
    }()
    
    lazy var maskView: UIView = {
        let maskView = UIView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        maskView.backgroundColor = UIColor.black
        maskView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeCommentInputView))
        maskView.addGestureRecognizer(gesture)
        maskView.alpha = 0.55
        return maskView
    }()
    
    lazy var commentRepliedViewController: OPFarmCommentRepliedTableViewController = {
        let commentRepliedViewController = UIStoryboard.init(name: "OPFarm", bundle: nil).instantiateViewController(withIdentifier: "OPFarmCommentRepliedTableViewController") as! OPFarmCommentRepliedTableViewController
        commentRepliedViewController.loadViewIfNeeded()
        return commentRepliedViewController
    }()
    
    lazy var commentInputView: UIView = {
        let commentInputView = OPCommentInputView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 136, width: UIScreen.main.bounds.width, height: 136))
        commentInputView.commentTextView.delegate = self
        return commentInputView
    }()
    
    lazy var setup: () = {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Comment")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        guard let id = self.farm?.id else { return }
        request.predicate = NSPredicate(format: "parent == nil AND object_id == %d", id)
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.dataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        self.showNoCommentView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        let _ = setup
        // Do any additional setup after loading the view.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func prepareUI() {
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()//remove the lines if there is no data
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
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
            })
        }

    }
    
    func closeCommentInputView() {
        maskView.isHidden = true
        let commentView = (commentInputView as? OPCommentInputView)?.commentTextView.customTextView
        commentView?.resignFirstResponder()
    }
    
    func keyBoardWillHide(_ notification: Notification){
        maskView.isHidden = true
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

        commentInputView.alpha = 0.0
        maskView.isHidden = true
        navigationController?.view.addSubview(maskView)
        navigationController?.view.addSubview(commentInputView)
        navigationController?.view.bringSubview(toFront: commentInputView)
        
        loadingNewData()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         delegate?.previousPage(currentScrollOffSet)
        let _ = commentRepliedViewController
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        commentInputView.removeFromSuperview()
    }
    
    func loadingNewData() {
        OPDataService.sharedInstance.getFarmComment(farm?.id) { [weak self](success, error) in
            self?.showNoCommentView()
            if success {
                print("get data successfully")
            } else {
                print("get the comment data failed")
            }
        }

    }
}

extension OPFarmCommentViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:50))
        headerView.backgroundColor = UIColor.white
        let commentlable = UILabel()
        commentlable.sizeToFit()
        commentlable.attributedText = NSAttributedString(string: "农场主期待您的留言", attributes: [NSForegroundColorAttributeName: UIColor(hexString: OPDarkGreenColor),NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 15)!])
        headerView.addSubview(commentlable)
        commentlable.translatesAutoresizingMaskIntoConstraints = false
        commentlable.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        commentlable.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 30).isActive = true
        
        let commentImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 28))
        commentImage.image = UIImage(named: "editer_gray")
        commentImage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showTopCommentView))
        commentImage.addGestureRecognizer(gesture)
        headerView.addSubview(commentImage)
        commentImage.translatesAutoresizingMaskIntoConstraints = false
        commentImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
        commentImage.heightAnchor.constraint(equalToConstant: 28).isActive = true
        commentImage.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        commentImage.leadingAnchor.constraint(equalTo: commentlable.trailingAnchor, constant: 20).isActive = true
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OPComentTableViewCell", for: indexPath) as! OPComentTableViewCell
        guard let comment = fetchedResultsController?.object(at: indexPath) as? Comment else { return cell }
        cell.updateDataSource(comment)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        parentComment = fetchedResultsController?.object(at: indexPath) as? Comment
        parentCellHeight = tableView.cellForRow(at: indexPath)?.frame.height
        
        if parentComment?.user?.username == appDelegate.currentUser?.username {
            guard let alterVC = showReplyAlertController(parentComment?.id, showDelete: true, commentId: parentComment?.id) else { return }
            present(alterVC, animated: true, completion: nil)
        } else {
            guard let alterVC = showReplyAlertController(parentComment?.id, commentId: parentComment?.id) else { return }
            present(alterVC, animated: true, completion: nil)
        }

        guard let alterVC = showReplyAlertController(parentComment?.id) else { return }
        present(alterVC, animated: true, completion: nil)
    }
    
    func showDetailedCommentsList() {
        guard let comment = parentComment, let height = parentCellHeight else { return }
        commentRepliedViewController.farm = farm
        commentRepliedViewController.parentComment = comment
        commentRepliedViewController.headViewHeight = height
        navigationController?.pushViewController(commentRepliedViewController, animated: true)
    }
    
    func showCommentView(_ parentId: Int64?) {
        maskView.isHidden = false
        let commentView = (commentInputView as? OPCommentInputView)?.commentTextView
        commentView?.parentId = parentId
        commentView?.customTextView.becomeFirstResponder()
    }
    
    func showTopCommentView() {
        maskView.isHidden = false
        let commentView = (commentInputView as? OPCommentInputView)?.commentTextView
        commentView?.parentId = nil
        commentView?.customTextView.becomeFirstResponder()
    }
    
    func deleteComment(_ commentId: Int64?, parentId: Int64?) {
        OPLoadingHUD.show(UIImage(named: "hud_loading"), title: "Deleting", animated: true, delay: 0.0)
        OPDataService.sharedInstance.deleteComment(commentId, parentId: parentId) { [weak self](success, error) in
            self?.showNoCommentView()
            if success {
                print("delete successfully")
            } else {
                print("delete failed")
            }
            OPLoadingHUD.hide()
        }
    }
    
    func showReplyAlertController(_ parentId: Int64? = nil, showDelete: Bool = false, commentId: Int64? = nil) -> UIAlertController? {
        replyAlertController = nil
        
        replyAlertController = UIAlertController(title: nil, message: nil, preferredStyle:UIAlertControllerStyle.actionSheet)
        replyAlertController?.view.tintColor = UIColor(hexString: OPGreenColor)
        
        let replyAction = UIAlertAction(title: "回复", style: .default, handler: { [weak self] (action) in
            self?.showCommentView(parentId)
        })
        replyAlertController?.addAction(replyAction)
        
        let replyDetailedAction = UIAlertAction(title: "查看详细回复", style: .default, handler: { [weak self] (action) in
            self?.showDetailedCommentsList()
        })
        replyAlertController?.addAction(replyDetailedAction)
        
        if showDelete {
            let deleteAction = UIAlertAction(title: "删除回复", style: .default, handler: { [weak self] (action) in
                self?.deleteComment(commentId, parentId: nil)
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

extension OPFarmCommentViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentScrollOffSet = scrollView.contentOffset.y
        delegate?.customScrollViewDidScroll(scrollView)
    }
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.hideOrShowBottomViewBeginScroll(scrollView)
    }
}

extension OPFarmCommentViewController: OPCommentTextViewDelegate {
    
    func sendMessage(_ message: String?, parent: Int64?, handler: @escaping (Bool, NSError?) -> Void) {
        OPLoadingHUD.show(UIImage(named: "hud_loading"), title: "Saving comment", animated: true, delay: 0.0)
        OPDataService.sharedInstance.createFarmComment(CommentType.farm.rawValue, object_id: farm?.id, parent_id: parent, content: message, grade: "5") {[weak self](success, error) in
            self?.showNoCommentView()
            if success {
                handler(true, nil)
                self?.tableView.scrollsToTop = true
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
    
    func showNoCommentView() {
        if let count = fetchedResultsController?.fetchedObjects?.count, count > 0 {
            noCommentView.isHidden = true
        } else {
            noCommentView.isHidden = false
        }
    }
}




