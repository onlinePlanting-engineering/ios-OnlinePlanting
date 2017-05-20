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
    
    lazy var commentRepliedViewController: OPFarmCommentRepliedTableViewController = {
        let commentRepliedViewController = UIStoryboard.init(name: "OPFarm", bundle: nil).instantiateViewController(withIdentifier: "OPFarmCommentRepliedTableViewController") as! OPFarmCommentRepliedTableViewController
        commentRepliedViewController.loadViewIfNeeded()
        return commentRepliedViewController
    }()
    
    lazy var commentBottmonView: UIView = {
        let commentBottmonView = OPCommentHereView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 44, width: UIScreen.main.bounds.width, height: 44))
        return commentBottmonView
    }()
    
    lazy var commentInputView: UIView = {
        let commentInputView = OPCommentInputView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 136, width: UIScreen.main.bounds.width, height: 136))
        commentInputView.commentTextView.delegate = self
        return commentInputView
    }()
    
    lazy var setup: () = {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FarmComment")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        request.predicate = NSPredicate(format: "parent == nil")
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.dataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        guard let count = self.fetchedResultsController?.fetchedObjects?.count else { return }
        (self.commentBottmonView as? OPCommentHereView)?.commentNumber.text = String(count)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        commentInputView.alpha = 0.0
        commentBottmonView.alpha = 1.0
        self.navigationController?.view.addSubview(commentBottmonView)
        self.navigationController?.view.bringSubview(toFront: commentBottmonView)
        
        self.navigationController?.view.addSubview(commentInputView)
        self.navigationController?.view.bringSubview(toFront: commentInputView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         delegate?.previousPage(currentScrollOffSet)
        let _ = commentRepliedViewController
        
        OPDataService.sharedInstance.getFarmComment(farm?.id) { (success, error) in
            if success {
                print("get data successfully")
            } else {
                print("get the comment data failed")
            }
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        commentBottmonView.removeFromSuperview()
        commentInputView.removeFromSuperview()
    }
}

extension OPFarmCommentViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OPComentTableViewCell", for: indexPath) as! OPComentTableViewCell
        guard let comment = fetchedResultsController?.object(at: indexPath) as? FarmComment else { return cell }
        guard let count = fetchedResultsController?.fetchedObjects?.count else { return cell }
        (commentBottmonView as? OPCommentHereView)?.commentNumber.text = String(count)
        cell.updateDataSource(comment)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let comment = fetchedResultsController?.object(at: indexPath) as? FarmComment , let height = tableView.cellForRow(at: indexPath)?.frame.height else { return }
        commentRepliedViewController.farm = farm
        commentRepliedViewController.parentComment = comment
        commentRepliedViewController.headViewHeight = height
        navigationController?.pushViewController(commentRepliedViewController, animated: true)
    }
}

extension OPFarmCommentViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentScrollOffSet = scrollView.contentOffset.y
        delegate?.customScrollViewDidScroll(scrollView)
    }
}

extension OPFarmCommentViewController: OPCommentTextViewDelegate {
    
    func sendMessage(_ message: String?, handler: @escaping (Bool, NSError?) -> Void) {
        OPLoadingHUD.show(UIImage(named: "hud_loading"), title: "Saving comment", animated: true, delay: 0.0)
        OPDataService.sharedInstance.createFarmComment(CommentType.farm.rawValue, object_id: farm?.id, parent_id: nil, content: message, grade: "5") {[weak self](success, error) in
            if success {
                handler(true, nil)
                (self?.commentBottmonView as? OPCommentHereView)?.textfield.text = ""
                (self?.commentBottmonView as? OPCommentHereView)?.textfield.resignFirstResponder()
            } else {
                handler(false, error)
                
            }
            OPLoadingHUD.hide()
        }
    }
    
    func saveMessageToContainer(_ message: String?) {
        (commentBottmonView as? OPCommentHereView)?.textfield.text = message
        (commentBottmonView as? OPCommentHereView)?.textfield.resignFirstResponder()
    }
}




