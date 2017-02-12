//
//  SaveTomatoViewController.swift
//  tomatoes-ios
//
//  Created by Giorgia Marenda on 1/22/17.
//  Copyright © 2017 Giorgia Marenda. All rights reserved.
//

import UIKit
import Tomatoes

class SaveTomatoViewController: UIViewController {
    
    var onDismiss: (()->())?
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.monospacedDigitSystemFont(ofSize: 90, weight: 200)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.enablesReturnKeyAutomatically = true
        textView.returnKeyType = .done
        textView.keyboardDismissMode = .interactive
        textView.autocorrectionType = .no
        textView.delegate = self
        textView.textColor = .redTomato
        textView.tintColor = .redTomato
        return textView
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: 200)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 60
        button.backgroundColor = .redTomato
        button.setTitle("SAVE", for: .normal)
        button.setTitleColor(.whiteSnow, for: .normal)
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupViews()
        registerKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        deregisterKeyboardNotification()
    }
    
    init(onDismiss: (()->())? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.onDismiss = onDismiss
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func save() {
        let taglist = textView.text ?? ""
        let tomato = Tomato()
        tomato.tagList = taglist
        tomato.create { [weak self] (result) in
            switch result {
            case .success:
                self?.dismiss(animated: true) { [weak self] in
                    self?.onDismiss?()
                }
            case .failure(let error): print(error?.localizedDescription ?? "")
            }
        }
    }
    
    func setupViews() {
        view.backgroundColor = .whiteSnow
        view.addSubview(textView)
        view.addSubview(saveButton)
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: [saveButton.widthAnchor.constraint(equalToConstant: 120),
                                        saveButton.heightAnchor.constraint(equalToConstant: 120),
                                        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                        saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)])
        
        constraints.append(contentsOf: [textView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                        textView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                        textView.topAnchor.constraint(equalTo: view.topAnchor),
                                        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: view.frame.height - saveButton.frame.minY, right: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Keyboard
    
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateBottomLayoutConstraintWithNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateBottomLayoutConstraintWithNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func updateBottomLayoutConstraintWithNotification(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }

        let convertedKeyboardEndFrame = textView.convert(keyboardEndFrame, from: textView.window)
        let bottom = max(view.frame.height - convertedKeyboardEndFrame.minY, view.frame.height - saveButton.frame.minY)
        textView.contentInset = UIEdgeInsets(top: textView.contentInset.top, left: textView.contentInset.left, bottom: bottom, right: textView.contentInset.right)
        textView.layoutIfNeeded()
    }
    
}

extension SaveTomatoViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
