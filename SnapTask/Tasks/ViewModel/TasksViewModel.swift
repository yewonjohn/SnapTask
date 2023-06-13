//
//  TasksViewModel.swift
//  OneTask
//
//  Created by John Kim on 5/17/23.
//

import CoreData

class TasksViewModel {
    //MARK: - Properties
    var tasks : [Task] = []
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "OneTask")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    lazy var managedObjectContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    //MARK: - Lifecycle methods
    init() {
        fetchTasks(){ tasks in
            self.tasks = tasks ?? []
        }
    }
    
    //MARK: - CoreData CRUD methods
    func addTask(text: String,_ completion: @escaping () -> Void) {
        let task = Task(context: managedObjectContext)
        task.text = text
        task.isComplete = false
        task.completeTriggered = .incomplete
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Failed to save todo item: \(error)")
        }
        fetchTasks() { tasks in
            self.tasks = tasks ?? []
            completion()
        }
    }
    
    func fetchTasks(_ completion: @escaping ([Task]?) -> Void) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            let tasks = try managedObjectContext.fetch(fetchRequest)
            completion(tasks)
        } catch {
            print("Failed to fetch todo items: \(error)")
        }
    }
    
    func deleteTask(_ task: Task) {
        managedObjectContext.delete(task)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Failed to delete todo item: \(error)")
        }
    }
    
    func updateTask(_ task: Task) {
        do {
            try managedObjectContext.save()
        } catch {
            print("Failed to update todo item: \(error)")
        }
    }

    //MARK: - Action methods
    func removeTask(at index: Int) {
        let task = tasks[index]
        tasks.remove(at: index)
        deleteTask(task)
    }
    
    func completeTask(at index: Int) {
        tasks[index].isComplete = true
        tasks[index].completeTriggered = .complete
        updateTask(tasks[index])
    }
    
    func incompleteTask(at index: Int) {
        tasks[index].isComplete = false
        tasks[index].completeTriggered = .incomplete
        updateTask(tasks[index])
    }
    
}
