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
    let viewModel : MainViewModel
    let homeViewModel: HomeViewModel
    var rowStates: [IndexPath: Bool] = [:]

    //MARK: - Lifecycle methods
    init(viewModel: MainViewModel, homeViewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.homeViewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
    }
    
    lazy var addTaskOverlayView : AddTaskOverlayView = {
        let addTaskOverlayView = AddTaskOverlayView(viewModel)
        return addTaskOverlayView
    }()
    
    lazy var backgroundView : UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()
    
    lazy var headerView : UIView = {
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()
    
    lazy var headerIcon : LottieAnimationView = {
       let headerIcon = LottieAnimationView(name: "notes")
        headerIcon.contentMode = .scaleAspectFit
        headerIcon.loopMode = .playOnce
        headerIcon.animationSpeed = 3
        headerIcon.translatesAutoresizingMaskIntoConstraints = false
//        headerIcon.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return headerIcon
    }()
    
    lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "OneTask"
        titleLabel.font = UIFont.systemFont(ofSize: 30)
        titleLabel.textColor = .darkText
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
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
        
        view.addSubview(backgroundView)
        view.addSubview(headerView)
        headerView.addSubview(headerIcon)
        headerView.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(addTaskOverlayView)
        
        addTaskOverlayView.delegate = self
        
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: -100).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100).isActive = true

        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        headerIcon.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        headerIcon.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 90).isActive = true
        headerIcon.heightAnchor.constraint(equalToConstant: 75).isActive = true
        headerIcon.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: headerIcon.trailingAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        addTaskOverlayView.translatesAutoresizingMaskIntoConstraints = false
        addTaskOverlayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        addTaskOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        addTaskOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addTaskOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension HomeScreen : UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let translation = scrollView.panGestureRecognizer.translation(in: view)
        let progress = translation.y / self.view.bounds.size.height
        let limitProgress = min(0.55, progress * 2)
        
        if offsetY < 0 && abs(offsetY) >= view.bounds.height * 0.15 {
            addTaskOverlayView.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.addTaskOverlayView.alpha = 0.9
                self.viewModel.showMenuButton = false
            }
        }
        if offsetY < 0 {
            self.headerIcon.play(fromProgress: limitProgress, toProgress: 0, loopMode: .playOnce)
        }
        UIView.animate(withDuration: 0.3){
            self.headerIcon.transform = .identity
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let recognizer = scrollView.panGestureRecognizer
        let translation = scrollView.panGestureRecognizer.translation(in: view)
        let offsetY = scrollView.contentOffset.y
        let progress = translation.y / self.view.bounds.size.height
        let limitProgress = min(0.55, progress * 2)

        //Header Label Animation
        let maxFontSize: CGFloat = 34.0
        let minFontSize: CGFloat = 30.0
        let maxScrollOffset: CGFloat = 100.0
        let fontSizeRange = maxFontSize - minFontSize
        
        let fontSize = max(maxFontSize - ((offsetY / maxScrollOffset) * fontSizeRange), minFontSize)
        let font = UIFont.systemFont(ofSize: fontSize)
        titleLabel.font = font
        
             switch recognizer.state {
             case .changed:
                 
                 if scrollView.isDragging == false && scrollView.isDecelerating == false {
                     print("inside dragging")
                     // The scroll has ended
                     if offsetY > 0 {
                         // Handle the end of scrolling down
                         addTaskOverlayView.isHidden = false
                         UIView.animate(withDuration: 0.5) {
                             self.addTaskOverlayView.alpha = 1.0
                         }
                         self.headerIcon.play(fromProgress: limitProgress, toProgress: 0, loopMode: .playOnce)
                     }
                 }
                 
                 if(offsetY < 0){
                     let maxScale: CGFloat = 1.5
                     let minScale: CGFloat = 1.0

                     let scaleRange = maxScale - minScale
                     let scale = min(maxScale, max(minScale, 1 + (-offsetY / maxScrollOffset) * scaleRange))
                     
                     headerIcon.transform = CGAffineTransform(scaleX: scale, y: scale)
                     headerIcon.currentProgress = limitProgress
                 }
             default:
                 break
             }

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.resuseIdentifier) as! TaskCell
        let task = homeViewModel.tasks[indexPath.row]

        cell.configure(with: task)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension HomeScreen : AddTaskOverlayViewDelegate {
    func addTask(_ task: String) {
        let newTask = TaskItem(name: task)
        self.homeViewModel.tasks.append(newTask)
        self.tableView.reloadData()
        self.viewModel.showMenuButton = true
    }
    
    func closeTapped() {
        self.viewModel.showMenuButton = true
    }
}

extension HomeScreen : TaskCellDelegate {
    func completeTaskTriggered(in cell: TaskCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        homeViewModel.toggleTaskCompletion(at: indexPath.row)
    }
    
    func didTapDeleteButton(in cell: TaskCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.homeViewModel.tasks.remove(at: indexPath.row)

            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
        }
    }
}

protocol TaskCellDelegate {
    func didTapDeleteButton(in cell: TaskCell)
    func completeTaskTriggered(in cell: TaskCell)
}

class TaskCell : UITableViewCell {
    static let resuseIdentifier = "TaskCell"
    var delegate: TaskCellDelegate?
    var task: TaskItem!

    lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "proxima_nova_thin", size: 16)
        label.textColor = .darkText
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
    
    var panGestureRecognizer: UIPanGestureRecognizer!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white

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
//        setup()
    }
    
    func setup() {
        if(task.isComplete){
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
    
    func configure(with item: TaskItem) {
        self.task = item
        self.taskLabel.text = task.name
        self.setup()
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
    
    @objc private func checkboxTapped() {
        delegate?.didTapDeleteButton(in: self)
    }
    
    
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: contentView)
        let progress = translation.x / self.contentView.bounds.size.width
        
        switch recognizer.state {
            case .changed:
                // Update the position of the contentView based on the translation
                contentView.transform = CGAffineTransform(translationX: translation.x, y: 0)
                
                // Apply spring animation to the textLabel and strikethroughView when swiped right
            if !task.isComplete {
                    if translation.x > 0 {
                        let maxOffset: CGFloat = 25
                        let offset = min(translation.x * 0.2, maxOffset)
                        taskLabel.transform = CGAffineTransform(translationX: offset, y: 0)
                        strikethroughView.transform = CGAffineTransform(translationX: offset * 1.2, y: 0)
                    } else {
//                        taskLabel.transform = .identity
//                        strikethroughView.transform = .identity
                    }
            } else if task.isComplete {
//                    strikethroughView.t
                }
                //animation: swiping strikethrough right
            if(!task.isComplete && progress < 0.20){
                    strikethroughView.currentProgress = progress
            } else if(!task.isComplete && progress > 0.20){
                    strikethroughView.play(fromProgress: 0.25, toProgress: 0.5, completion: { _ in
                        UIView.animate(withDuration: 0.3) {
                            self.taskLabel.alpha = 0.5
                        }
                        self.checkboxView.isHidden = false
                        self.checkboxView.play()
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.task.isComplete = true
                        self.delegate?.completeTaskTriggered(in: self)
//                        }
                    })
                }
                //animation: swiping strikethrough left
            else if(task.isComplete && progress < 0 && progress > -0.13){
                    let currProgress = 0.5 - abs(progress)
                    strikethroughView.currentProgress = currProgress
            } else if(task.isComplete && progress < 0 && progress < -0.13){
                    strikethroughView.play(fromProgress: 0.5, toProgress: 0, completion: { _ in
                        UIView.animate(withDuration: 0.3) {
                            self.taskLabel.alpha = 1
                        }
                    })
                    self.checkboxView.play(fromProgress: 0.6, toProgress: 0, completion: { _ in
                        self.checkboxView.isHidden = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.task.isComplete = false
                            self.delegate?.completeTaskTriggered(in: self)
                        }
                    })
                }

            case .ended:
                // Reset the contentView position and textLabel transform
                UIView.animate(withDuration: 0.3) {
                    self.taskLabel.transform = .identity
                    self.strikethroughView.transform = .identity
                }
            
//                UIView.animate(withDuration: 3) {
            if(!self.task.isComplete && progress > 0 && progress < 0.20){
                        self.strikethroughView.play(fromProgress: self.strikethroughView.realtimeAnimationProgress, toProgress: 0)
            } else if(self.task.isComplete && progress < 0 && progress > -0.13){
                        self.strikethroughView.play(fromProgress: self.strikethroughView.realtimeAnimationProgress, toProgress: 0.5)
                    }
//                }

            default:
                break
        }
    }
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
         return true
     }
}



struct TodoView: UIViewControllerRepresentable {
    let viewModel : MainViewModel

    init(_ viewModel: MainViewModel){
        self.viewModel = viewModel
    }

    func makeUIViewController(context: Context) -> HomeScreen {
        let todoViewController = HomeScreen(viewModel: viewModel, homeViewModel: HomeViewModel())
        return todoViewController
    }
    
    func updateUIViewController(_ uiViewController: HomeScreen, context: Context) {
        // Update the view controller if needed
    }
}
