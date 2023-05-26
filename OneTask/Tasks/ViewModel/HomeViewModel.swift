//
//  HomeViewModel.swift
//  OneTask
//
//  Created by John Kim on 5/17/23.
//

import Foundation

class HomeViewModel {
    
    var tasks : [Task] = []
    
    init() {
        self.populateData()
    }

    private func populateData(){
        tasks = [Task(name: "something to do ", isComplete: false), Task(name: "get bread", isComplete: false), Task(name: "buy groceries", isComplete: false),Task(name: "play boardgames", isComplete: false), Task(name: "do task 5", isComplete: false), Task(name: "help something with niece", isComplete: false), Task(name: "buy something from amazon", isComplete: false), Task(name: "study this", isComplete: false),Task(name: "study that", isComplete: false), Task(name: "study something", isComplete: false),Task(name: "eat cereal", isComplete: false), Task(name: "workout legs", isComplete: false), Task(name: "workout right arm", isComplete: false),Task(name: "workout hips", isComplete: false), Task(name: "sit up straight", isComplete: false),Task(name: "implement a better note taking app", isComplete: false), Task(name: "this is pretty good", isComplete: false), Task(name: "publish to app store", isComplete: false),Task(name: "publish to connect", isComplete: false), Task(name: "dispatch to test group", isComplete: false)]
    }
    
    func removeTask(at index: Int) {
        tasks.remove(at: index)
    }
    
    func toggleTaskCompletion(at index: Int) {
        tasks[index].isComplete.toggle()
        tasks[index].completeTriggered = (tasks[index].completeTriggered == .incomplete) ? .complete : .incomplete
    }
    
}
