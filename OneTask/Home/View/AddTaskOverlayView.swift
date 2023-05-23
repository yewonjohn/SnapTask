//
//  AddTaskOverlayView.swift
//  OneTask
//
//  Created by John Kim on 5/16/23.
//

import UIKit
import SwiftUI

protocol AddTaskOverlayViewDelegate {
    func addTask(_ task: String)
    func closeTapped()
}

class AddTaskOverlayView: UIView {
    
    var delegate : AddTaskOverlayViewDelegate?
    var panGestureRecognizer: UIPanGestureRecognizer!

    required init(_ viewModel: MainViewModel){
        super.init(frame: CGRect.zero)
        configureLayout()
        initializeHideKeyboard()
        addDoneButtonToKeyboard(textInput: taskTextView)
        self.alpha = 0
        // Can't call super.init() here because it's a convenience initializer not a desginated initializer
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var taskTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 30)
        textView.isScrollEnabled = false
        textView.textColor = .darkGray
        textView.backgroundColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var addTaskButton : UIButton = {
        let button = UIButton()
        button.setTitle("Add Task", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var closeButton : UIButton = {
        let button = UIButton()
        if let image = UIImage(systemName: "xmark") {
            let tintedImage = image.withTintColor(.black, renderingMode: .alwaysOriginal)
            button.setBackgroundImage(tintedImage, for: .normal)
        }
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()

    private func configureLayout() {
        backgroundColor = .white
        addSubview(taskTextView)
        addSubview(closeButton)
        addSubview(addTaskButton)
        isHidden = true
        
        taskTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        taskTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        taskTextView.topAnchor.constraint(equalTo: topAnchor, constant: 45).isActive = true
        taskTextView.bottomAnchor.constraint(equalTo: addTaskButton.topAnchor, constant: -16).isActive = true
        
        closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        addTaskButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        addTaskButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25).isActive = true
        addTaskButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        addTaskButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc private func addTaskButtonTapped() {
        guard let taskText = taskTextView.text, taskText != "" else {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { _ in
                self.isHidden = true
            }
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.isHidden = true
        }
        delegate?.addTask(taskTextView.text)
        taskTextView.text = ""
        endEditing(true)
    }
    
    @objc private func closeButtonTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.isHidden = true
        }
        delegate?.closeTapped()
        endEditing(true)
    }
    
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(dismissMyKeyboard))
        
        self.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        self.endEditing(true)
    }
    
}

//Adding Done Button on Keyboard
extension AddTaskOverlayView {
    func addDoneButtonToKeyboard(textInput: UITextInput) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [flexBarButton, doneBarButton]
        
        if let textField = textInput as? UITextField {
            textField.inputAccessoryView = toolbar
        } else if let textView = textInput as? UITextView {
            textView.inputAccessoryView = toolbar
        }
    }
    
    @objc func doneButtonTapped() {
        self.endEditing(true)
    }
}
