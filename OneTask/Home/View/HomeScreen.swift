//
//  HomeScreen.swift
//  OneTask
//
//  Created by John Kim on 5/15/23.
//

import Foundation
import UIKit
import Lottie
import SwiftUI

class HomeScreen : UIViewController {
    var items = ["Task 1", "task 2", "Task 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        
    }
    
    lazy var tableView : UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.resuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        return tableView
    }()
    
    
    func configureLayout(){
        view.backgroundColor = .white

        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    

}

extension HomeScreen : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.resuseIdentifier) as! TaskCell
        cell.taskLabel.text = items[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


class TaskCell : UITableViewCell {
    static let resuseIdentifier = "TaskCell"
    var isComplete = false
    
    lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "proxima_nova_thin", size: 16)
        label.textColor = .black
        return label
    }()
    
    lazy var strikethroughView : LottieAnimationView = {
       let animationView = LottieAnimationView(name: "strikethrough2")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1.5
        animationView.isHidden = true
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    lazy var checkboxView : LottieAnimationView = {
        let animationView = LottieAnimationView(name: "check")
        animationView.contentMode = .scaleAspectFit
//        animationView.backgroundColor = .darkGray
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false

        return animationView
    }()
    
    var panGestureRecognizer: UIPanGestureRecognizer!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white

        setupViews()

        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        contentView.addGestureRecognizer(panGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(taskLabel)
        contentView.addSubview(strikethroughView)
        contentView.addSubview(checkboxView)
        
        NSLayoutConstraint.activate([
            taskLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            taskLabel.trailingAnchor.constraint(equalTo: checkboxView.leadingAnchor, constant: -16),
            taskLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            strikethroughView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            strikethroughView.trailingAnchor.constraint(equalTo: checkboxView.leadingAnchor, constant: -16),
            strikethroughView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 3),
            
            checkboxView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            checkboxView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            checkboxView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            checkboxView.heightAnchor.constraint(equalToConstant: 30),
            checkboxView.widthAnchor.constraint(equalToConstant: 30),
            
        ])
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: contentView)
        let progress = translation.x / self.contentView.bounds.size.width
        
        switch recognizer.state {
            case .changed:
                // Update the position of the contentView based on the translation
                contentView.transform = CGAffineTransform(translationX: translation.x, y: 0)
                
                // Apply spring animation to the textLabel and strikethroughView when swiped right
                if translation.x > 0 {
                    let maxOffset: CGFloat = 20
                    let offset = min(translation.x * 0.2, maxOffset)
                    taskLabel.transform = CGAffineTransform(translationX: offset, y: 0)
                    strikethroughView.transform = CGAffineTransform(translationX: offset, y: 0)
                } else {
                    taskLabel.transform = .identity
                    strikethroughView.transform = .identity
                }
                
                //Apply onGesture animation for swiping right (completing task)
                if(!isComplete && progress < 0.20){
                    strikethroughView.isHidden = false
                    strikethroughView.currentProgress = progress
                } else if(!isComplete && progress > 0.20){
                    strikethroughView.play(fromProgress: 0.25, toProgress: 0.5, completion: nil)
                    isComplete = true
                }

            case .ended:
                // Reset the contentView position and textLabel transform
                UIView.animate(withDuration: 0.3) {
                    self.taskLabel.transform = .identity
                    self.strikethroughView.transform = .identity
                }
                // Reset strikethrough animation when isComplete is not triggered
                if(!isComplete){
                    strikethroughView.isHidden = true
                    strikethroughView.currentProgress = 0
                }
            default:
                break
        }
    }
}




struct TodoView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> HomeScreen {
        let todoViewController = HomeScreen()
        return todoViewController
    }
    
    func updateUIViewController(_ uiViewController: HomeScreen, context: Context) {
        // Update the view controller if needed
    }
}
