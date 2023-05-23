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
        tasks = [TaskItem(name: "1", isComplete: true), TaskItem(name: "2", isComplete: true), TaskItem(name: "3", isComplete: true),TaskItem(name: "4", isComplete: true), TaskItem(name: "5", isComplete: true), TaskItem(name: "6", isComplete: true), TaskItem(name: "7", isComplete: true), TaskItem(name: "8", isComplete: true),TaskItem(name: "9", isComplete: true), TaskItem(name: "10", isComplete: true),TaskItem(name: "11", isComplete: true), TaskItem(name: "12", isComplete: true), TaskItem(name: "13", isComplete: true),TaskItem(name: "14", isComplete: true), TaskItem(name: "15", isComplete: true),TaskItem(name: "16", isComplete: true), TaskItem(name: "17", isComplete: true), TaskItem(name: "18", isComplete: true),TaskItem(name: "19", isComplete: true), TaskItem(name: "20", isComplete: true)]
    }
    
    func toggleTaskCompletion(at index: Int) {
        tasks[index].isComplete.toggle()
    }
    
}
