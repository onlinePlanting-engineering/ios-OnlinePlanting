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
    
    lazy var customTextView: UITextView = {
        let customTextView = UITextView()
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
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        delegate?.sendMessage(customTextView.text, handler: { [weak self](success, error) in
            if success {
                //TODO: success
                self?.customTextView.text = ""
                
            } else {
                //
            }
            self?.isSending = false
        })
    }
}

extension OPCommentTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //
    }
}
