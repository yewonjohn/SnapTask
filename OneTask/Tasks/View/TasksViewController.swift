//
//  TaskViewController.swift
//  OneTask
//
//  Created by John Kim on 5/15/23.
//

import Foundation
import UIKit
import Lottie
import SwiftUI
import Combine

class TasksViewController : UIViewController {
    //MARK: - Properties
    let mainViewModel : MainViewModel
    let homeViewModel: TasksViewModel
    var rowStates: [IndexPath: Bool] = [:]

    //MARK: - Lifecycle methods
    init(viewModel: MainViewModel, homeViewModel: TasksViewModel) {
        self.mainViewModel = viewModel
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
    
    //MARK: - UI Properties
    lazy var addTaskOverlayView : AddTaskOverlayView = {
        let addTaskOverlayView = AddTaskOverlayView(AddTaskOverlayViewModel())
        if let viewModel = addTaskOverlayView.viewModel {
            viewModel.addTask.compactMap{$0}
                .sink{ text in
                    self.homeViewModel.addTask(text: text) {
                        self.tableView.reloadData()
                    }
                    self.mainViewModel.enableMenuButton()
                }.store(in: &viewModel.cancellables)
            
            viewModel.closeTapped.compactMap{$0}
                .sink{
                    self.mainViewModel.enableMenuButton()
                }.store(in: &viewModel.cancellables)
        }

        
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

    //MARK: - Setup methods
    func configureLayout(){
        view.backgroundColor = .white
        
        view.addSubview(backgroundView)
        view.addSubview(headerView)
        headerView.addSubview(headerIcon)
        headerView.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(addTaskOverlayView)
        
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

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
//MARK: - Gesture animations
extension TasksViewController : UIGestureRecognizerDelegate {
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
                self.mainViewModel.disableMenuButton()
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
                    if offsetY > 0 {
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
}

//MARK: - Tableview config
extension TasksViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.resuseIdentifier) as! TaskCell
        let task = homeViewModel.tasks[indexPath.row]

        cell.configure(with: task, viewModel: TaskCellViewModel())
        if let viewModel = cell.viewModel {
            
            viewModel.completeTriggered.compactMap{$0}
                .sink { taskCell in
                    guard let indexPath = tableView.indexPath(for: taskCell) else { return }
                    self.homeViewModel.completeTask(at: indexPath.row)
                }.store(in: &viewModel.cancellables)
            
            viewModel.incompleteTriggered.compactMap{$0}
                .sink { taskCell in
                    guard let indexPath = tableView.indexPath(for: taskCell) else { return }
                    self.homeViewModel.incompleteTask(at: indexPath.row)
                }.store(in: &viewModel.cancellables)
            
            viewModel.deleteTapped.compactMap{$0}
                .sink { taskCell in
                    guard let indexPath = tableView.indexPath(for: taskCell) else { return }
                        UIView.animate(withDuration: 0.3) {
                            self.homeViewModel.removeTask(at: indexPath.row)
                            self.tableView.beginUpdates()
                            self.tableView.deleteRows(at: [indexPath], with: .left)
                            self.tableView.endUpdates()
                        }
                }.store(in: &viewModel.cancellables)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//MARK: - UIViewControllerRepresentable
struct TodoView: UIViewControllerRepresentable {
    let viewModel : MainViewModel

    init(_ viewModel: MainViewModel){
        self.viewModel = viewModel
    }

    func makeUIViewController(context: Context) -> TasksViewController {
        let todoViewController = TasksViewController(viewModel: viewModel, homeViewModel: TasksViewModel())
        return todoViewController
    }
    
    func updateUIViewController(_ uiViewController: TasksViewController, context: Context) {
    }
}
