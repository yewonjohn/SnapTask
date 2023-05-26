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
    private(set) var incompleteTriggered = PassthroughSubject<TaskCell?, Never>()

    func removeCancellables() {
        cancellables.removeAll()
    }
    
    func deleteTapped(_ taskCell: TaskCell) {
        self.deleteTapped.send(taskCell)
    }
    
    func taskCompleted(_ taskCell: TaskCell) {
        self.completeTriggered.send(taskCell)
        self.task.completeTriggered = .complete
        self.task.isComplete = true
    }
    
    func taskIncompleted(_ taskCell: TaskCell){
        self.incompleteTriggered.send(taskCell)
        self.task.completeTriggered = .incomplete
        self.task.isComplete = false
    }
}
