//
//  TaskCellViewModel.swift
//  OneTask
//
//  Created by John Kim on 5/25/23.
//

import Foundation
import Combine

class TaskCellViewModel {
    
    var task: Task!
    var cancellables: Set<AnyCancellable> = []
    private(set) var deleteTapped = PassthroughSubject<TaskCell?, Never>()
    private(set) var completeTriggered = PassthroughSubject<TaskCell?, Never>()

    func removeCancellables() {
        cancellables.removeAll()
    }
    
    func deleteTapped(_ task: TaskCell) {
        self.deleteTapped.send(task)
    }
    
    func taskCompleted(_ task: TaskCell) {
        self.task.isComplete = true
        self.task.completeTriggered = .complete
        self.completeTriggered.send(task)
    }
    
    func taskIncompleted(_ task: TaskCell){
        self.task.isComplete = false
        self.task.completeTriggered = .incomplete
        self.completeTriggered.send(task)
    }
}
