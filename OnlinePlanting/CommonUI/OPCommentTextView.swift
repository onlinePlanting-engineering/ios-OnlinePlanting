//
//  OPCommentTextView.swift
//  cellWebview
//
//  Created by IBM on 5/12/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

protocol OPCommentTextViewDelegate: NSObjectProtocol {
    func sendMessage(_ message: String?, handler: @escaping(_ success: Bool, _ error: NSError?) -> Void)
    func saveMessageToContainer(_ message: String?)
}

@IBDesignable
class OPCommentTextView: UIView {
    
    weak var delegate: OPCommentTextViewDelegate?
    fileprivate var isSending = false
    @IBInspectable var sendButtonTitle: String? {
        didSet {
            self.sendButton.setTitle(sendButtonTitle, for: .normal)
            guard let title = sendButtonTitle else { return }
            self.sendButton.setAttributedTitle(NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 12)! , ]), for: .normal)
        }
    }
    
    @IBInspectable var sendButtonColor: UIColor? {
        didSet {
            self.sendButton.backgroundColor = sendButtonColor
        }
    }
    
    @IBInspectable var textViewBackground: UIColor? {
        didSet {
            self.customTextView.backgroundColor = textViewBackground
        }
    }
    
    
    lazy var sendButton: UIButton = {
        let sendButton = UIButton()
        sendButton.layer.cornerRadius = 3
        sendButton.layer.masksToBounds = true
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        self.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.widthAnchor.constraint(equalToConstant: 52).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: self.customTextView.trailingAnchor).isActive = true
        sendButton.topAnchor.constraint(equalTo: self.customTextView.bottomAnchor, constant: 10).isActive = true
        return sendButton
    }()
    
    lazy var closeKeyboardButton: UIImageView = {
        let closeKeyboardButton = UIImageView()
        closeKeyboardButton.isUserInteractionEnabled = true
        closeKeyboardButton.image = UIImage.init(named: "keyboard_close")
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(closeKeyBoard))
        closeKeyboardButton.addGestureRecognizer(gesture)
        self.addSubview(closeKeyboardButton)
        closeKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        closeKeyboardButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        closeKeyboardButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        closeKeyboardButton.trailingAnchor.constraint(equalTo: self.sendButton.leadingAnchor, constant: -20).isActive = true
        closeKeyboardButton.topAnchor.constraint(equalTo: self.sendButton.topAnchor).isActive = true
        return closeKeyboardButton
    }()
    
    lazy var customTextView: UITextView = {
        let customTextView = UITextView()
        customTextView.delegate = self
        customTextView.resignFirstResponder()
        self.addSubview(customTextView)
        customTextView.layer.borderWidth = 0.6
        customTextView.layer.borderColor = UIColor.lightGray.cgColor
        customTextView.layer.cornerRadius = 3
        customTextView.layer.masksToBounds = true
        customTextView.translatesAutoresizingMaskIntoConstraints = false
        customTextView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        customTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        customTextView.widthAnchor.constraint(equalToConstant: self.bounds.width - 20).isActive = true
        customTextView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return customTextView
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    
    }
    
    override func didMoveToSuperview() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        customTextView.resignFirstResponder()
        let _ = closeKeyboardButton
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func closeKeyBoard() {
        customTextView.resignFirstResponder()
    }
    
    func keyBoardWillShow(_ notification: Notification){
        
    }
    
    func keyBoardWillHide(_ notification: Notification){
        if isSending {
            return
        } else {
            delegate?.saveMessageToContainer(customTextView.text)
        }
    }
    
    func sendMessage() {
        guard let content = customTextView.text else { return }
        if content  == "" || content.characters.count <= 0 {
            return
        }
        
        let separateArray = content.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        var count = 0
        for separateArray in separateArray {
            if separateArray != "" {
                count += 1
            }
        }
        
        if count <= 0 {
            customTextView.text = ""
            return
        }
        isSending = true
        customTextView.resignFirstResponder()
        delegate?.sendMessage(customTextView.text, handler: { [weak self](success, error) in
            if success {
                //TODO: success
                self?.customTextView.text = ""
                self?.customTextView.resignFirstResponder()
            } else {
                self?.customTextView.becomeFirstResponder()
            }
            self?.isSending = false
        })
    }
}

extension OPCommentTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //
        print("here")
    }
}
