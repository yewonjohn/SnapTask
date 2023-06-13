//
//  TaskCell.swift
//  OneTask
//
//  Created by John Kim on 5/25/23.
//

import Foundation
import UIKit
import Lottie
import Combine

class TaskCell : UITableViewCell {
    static let resuseIdentifier = "TaskCell"

    //MARK: - Properties
    var viewModel : TaskCellViewModel?
    var panGestureRecognizer: UIPanGestureRecognizer!

    //MARK: - UI Properties
    lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "proxima_nova_light", size: 18)
        label.textColor = UIColor(hex: "#374259")
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    lazy var strikethroughView : LottieAnimationView = {
       let animationView = LottieAnimationView(name: "strikethrough2")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1.7
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.alpha = 0.65
        return animationView
    }()
    
    lazy var checkboxView : LottieAnimationView = {
        let animationView = LottieAnimationView(name: "check3")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.isHidden = true
        animationView.animationSpeed = 2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkboxTapped))
        animationView.addGestureRecognizer(tapGesture)
        animationView.isUserInteractionEnabled = true
        return animationView
    }()
    
    //MARK: - Lifecycle methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hex: "#F1F6F9")

        setupViews()
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.delegate = self
        contentView.addGestureRecognizer(panGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.removeCancellables()
    }
    
    //MARK: - Setup methods
    func configure(with item: Task, viewModel: TaskCellViewModel) {
        self.viewModel = viewModel
        viewModel.task = item
        self.taskLabel.text = item.text
        self.setup()
    }
    
    private func setup() {
        if let viewModel = viewModel {
            if(viewModel.task.isComplete){
                strikethroughView.currentProgress = 0.5
                taskLabel.alpha = 0.5
                checkboxView.isHidden = false
                checkboxView.currentProgress = 1
            } else {
                strikethroughView.currentProgress = 0
                taskLabel.alpha = 1
                checkboxView.isHidden = true
                checkboxView.currentProgress = 0
            }
        }
    }
    
    private func setupViews() {
        contentView.addSubview(taskLabel)
        contentView.addSubview(strikethroughView)
        contentView.addSubview(checkboxView)
        
        NSLayoutConstraint.activate([
            taskLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            taskLabel.trailingAnchor.constraint(equalTo: checkboxView.leadingAnchor, constant: -6),
            taskLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            strikethroughView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            strikethroughView.trailingAnchor.constraint(equalTo: checkboxView.leadingAnchor, constant: -5),
            strikethroughView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 3),
            
            checkboxView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkboxView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            checkboxView.heightAnchor.constraint(equalToConstant: 30),
            checkboxView.widthAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    //MARK: - Action handler methods

    @objc private func checkboxTapped() {
        viewModel?.deleteTapped(self)
    }
    
    
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: contentView)
        let progress = translation.x / self.contentView.bounds.size.width
        
        switch recognizer.state {
            case .changed:
                // Update the position of the contentView based on the translation
                contentView.transform = CGAffineTransform(translationX: translation.x, y: 0)
                // Apply spring animation to the textLabel and strikethroughView when swiped right
                if let viewModel = viewModel {
                    if !viewModel.task.isComplete {
                        if translation.x > 0 {
                            let maxOffset: CGFloat = 25
                            let offset = min(translation.x * 0.2, maxOffset)
                            taskLabel.transform = CGAffineTransform(translationX: offset, y: 0)
                            strikethroughView.transform = CGAffineTransform(translationX: offset * 1.2, y: 0)
                        }
                    }
                
                
                //animation: swiping strikethrough right
                if(!viewModel.task.isComplete && progress < 0.20 && progress > 0){
                    strikethroughView.currentProgress = progress
                } else if(!viewModel.task.isComplete && viewModel.task.completeTriggered == .incomplete && progress > 0.20){
                    viewModel.taskCompleted(self)
                    strikethroughView.play(fromProgress: 0.25, toProgress: 0.5, completion: { _ in
                        UIView.animate(withDuration: 0.3) {
                            self.taskLabel.alpha = 0.5
                        }
                        self.checkboxView.isHidden = false
                        self.checkboxView.play()
                    })
                }
                //animation: swiping strikethrough left
                else if(viewModel.task.isComplete && progress < 0 && progress > -0.13){
                    let currProgress = 0.5 - abs(progress)
                    strikethroughView.currentProgress = currProgress
                } else if(viewModel.task.isComplete && viewModel.task.completeTriggered == .complete && progress < 0 && progress < -0.13){
                    viewModel.task.completeTriggered = .incomplete
                    strikethroughView.play(fromProgress: 0.5, toProgress: 0)
                    UIView.animate(withDuration: 0.8) {
                        self.taskLabel.alpha = 1
                    }
                    checkboxView.play(fromProgress: 0.6, toProgress: 0, completion: { _ in
                        self.checkboxView.isHidden = true
                        viewModel.taskIncompleted(self)
                    })
                }
            }
            // Reset the contentView position and textLabel transform
            case .ended:
                UIView.animate(withDuration: 0.3) {
                    self.taskLabel.transform = .identity
                    self.strikethroughView.transform = .identity
                }
            if let viewModel = viewModel {
                if(!viewModel.task.isComplete && progress > 0 && progress < 0.20){
                    self.strikethroughView.play(fromProgress: self.strikethroughView.realtimeAnimationProgress, toProgress: 0)
                } else if(viewModel.task.isComplete && progress < 0 && progress > -0.13){
                    self.strikethroughView.play(fromProgress: self.strikethroughView.realtimeAnimationProgress, toProgress: 0.5)
                }
            }
            
            default:
                break
        }
    }
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
         return true
     }
}
