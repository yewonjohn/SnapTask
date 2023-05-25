//
//  TaskItem.swift
//  OneTask
//
//  Created by John Kim on 5/19/23.
//

import Foundation

struct TaskItem {
    var name: String
    var isComplete: Bool = false
    var completeTriggered : CompleteTriggered = .incomplete
}

enum CompleteTriggered {
    case complete
    case incomplete
}