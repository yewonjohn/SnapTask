//
//  HomeViewModel.swift
//  OneTask
//
//  Created by John Kim on 5/17/23.
//

import Foundation

class HomeViewModel {
    
    var tasks : [TaskItem] = []
    
    init() {
        self.populateData()
    }

    private func populateData(){
        tasks = [TaskItem(name: "something to do ", isComplete: false), TaskItem(name: "get bread", isComplete: false), TaskItem(name: "buy groceries", isComplete: false),TaskItem(name: "play boardgames", isComplete: false), TaskItem(name: "do task 5", isComplete: false), TaskItem(name: "help something with niece", isComplete: false), TaskItem(name: "buy something from amazon", isComplete: false), TaskItem(name: "study this", isComplete: false),TaskItem(name: "study that", isComplete: false), TaskItem(name: "study something", isComplete: false),TaskItem(name: "eat cereal", isComplete: false), TaskItem(name: "workout legs", isComplete: false), TaskItem(name: "workout right arm", isComplete: false),TaskItem(name: "workout hips", isComplete: false), TaskItem(name: "sit up straight", isComplete: false),TaskItem(name: "implement a better note taking app", isComplete: false), TaskItem(name: "this is pretty good", isComplete: false), TaskItem(name: "publish to app store", isComplete: false),TaskItem(name: "publish to connect", isComplete: false), TaskItem(name: "dispatch to test group", isComplete: false)]
    }
    
    func removeTask(at index: Int) {
        tasks.remove(at: index)
    }
    
    func toggleTaskCompletion(at index: Int) {
        tasks[index].isComplete.toggle()
        tasks[index].completeTriggered = (tasks[index].completeTriggered == .incomplete) ? .complete : .incomplete
    }
    
}
