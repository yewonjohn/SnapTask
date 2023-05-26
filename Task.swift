//
//  Task+CoreDataProperties.swift
//  OneTask
//
//  Created by John Kim on 5/25/23.
//
//

import Foundation
import CoreData


public class Task: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var text: String?
    @NSManaged public var isComplete: Bool
    @NSManaged public var completeTriggeredRaw: Int16

    var completeTriggered: CompleteTriggered {
        get {
            return CompleteTriggered(rawValue: completeTriggeredRaw) ?? .incomplete
        }
        set {
            completeTriggeredRaw = newValue.rawValue
        }
    }
}

extension Task : Identifiable {

}

enum CompleteTriggered: Int16 {
    case complete
    case incomplete
}
