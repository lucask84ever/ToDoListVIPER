//
//  CoreDataTaskRepository.swift
//  ToDoListVIPER
//
//  Created by Lucas on 21/04/25.
//

import CoreData

final class CoreDataTaskRepository: TaskRepositoryProtocol {
    
    private let context: NSManagedObjectContext
    private var observers = NSHashTable<AnyObject>.weakObjects()
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
//    func addObserver(_ observer: TaskRepositoryObserver) {
//        observers.add(observer)
//    }
    
    private func notifyObservers() {
//        observers.allObjects.forEach {
//            ($0 as? TaskRepositoryObserver)?.taskRepositoryDidUpdateTasks()
//        }
    }
    
    func tasksFromFetch(_ fetchRequest: NSFetchRequest<TaskEntity>) -> [Task] {
        let results = (try? context.fetch(fetchRequest)) ?? []
        return results.compactMap { $0.toModel() }
    }
    
    var tasks: [Task] {
        tasksFromFetch(TaskEntity.fetchRequest())
    }
    
    func getCompletedTasks() -> [Task] {
        let req: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        req.predicate = NSPredicate(format: "isDone == true")
        return tasksFromFetch(req)
    }

    func getPendingTasks() -> [Task] {
        let req: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        req.predicate = NSPredicate(format: "isDone == false")
        return tasksFromFetch(req)
    }

    func add(_ task: Task) {
        let entity = TaskEntity(context: context)
        entity.id = task.id
        entity.title = task.title
        entity.isDone = task.isDone
        entity.createdAt = task.createdAt
        entity.completedAt = task.completedAt
        CoreDataStack.shared.saveContext()
        notifyObservers()
    }

    func toggleCompletion(for task: Task) {
        let req: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        req.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        if let entity = (try? context.fetch(req))?.first {
            entity.isDone.toggle()
            entity.completedAt = entity.isDone ? Date() : nil
            CoreDataStack.shared.saveContext()
            notifyObservers()
        }
    }
}
