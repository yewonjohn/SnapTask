//
//  EditTaskOverlayView.swift
//  OneTask
//
//  Created by John Kim on 5/27/23.
//

import UIKit
import SwiftUI

class EditTaskOverlayView: UIView {
    //MARK: - Properties
    var viewModel: EditTaskOverlayViewModel?
    var panGestureRecognizer: UIPanGestureRecognizer!

    //MARK: - Lifecycle methods
    required init(_ viewModel: EditTaskOverlayViewModel){
        super.init(frame: CGRect.zero)
        self.viewModel = viewModel
        configureLayout()
        initializeHideKeyboard()
        addDoneButtonToKeyboard(textInput: taskTextView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        viewModel?.removeCancellables()
    }
    
    //MARK: - UI Properties
    lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(hex: "#F1F6F9")
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()
    
    lazy var addTaskButton : UIButton = {
        let button = UIButton()
        button.setTitle("Add Task", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor(hex: "#9BA4B5")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editTaskButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var taskTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "ProximaNova-Regular", size: 28)
        textView.isScrollEnabled = true
        textView.textColor = UIColor(hex: "#394867")
        textView.backgroundColor = .white
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
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
    
    //MARK: - Setup methods
    private func configureLayout() {
        alpha = 0
        backgroundColor = UIColor(hex: "#F1F6F9")
        isHidden = true

//        addSubview(backgroundView)
        addSubview(taskTextView)
        addSubview(addTaskButton)
        addSubview(closeButton)
        
        taskTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        taskTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25).isActive = true
        taskTextView.topAnchor.constraint(equalTo: topAnchor, constant: 145).isActive = true
        taskTextView.bottomAnchor.constraint(equalTo: addTaskButton.topAnchor).isActive = true
        
        closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 110).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        addTaskButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        addTaskButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25).isActive = true
        addTaskButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -116).isActive = true
        addTaskButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    @objc private func editTaskButtonTapped() {
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
//        viewModel?.(taskTextView.text)
        taskTextView.text = ""
        endEditing(true)
    }
    
    @objc private func closeButtonTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.isHidden = true
        }
        viewModel?.dismissScreen()
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

extension EditTaskOverlayView : UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        viewModel?.editTask(text: textView.text)
    }
}

//MARK: - Keyboard config
extension EditTaskOverlayView {
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
